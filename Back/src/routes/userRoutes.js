const express = require('express');
const router = express.Router();
const User = require('../models/userModel');
const bcrypt = require('bcrypt'); // Para comparar senhas
const jwt = require('jsonwebtoken'); // Para gerar tokens JWT

// Rota para criar um novo usuário
router.post('/', async (req, res) => {
    const user = new User({
        nome: req.body.nome,
        email: req.body.email,
        senha: await bcrypt.hash(req.body.senha, 10) // Hashing a senha antes de salvar
    });

    try {
        const newUser = await user.save();
        res.status(201).json(newUser);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

// Rota para obter um usuário pelo ID
router.get('/:id', getUser, (req, res) => {
    res.json(res.user);
});

// Middleware para obter um usuário pelo ID
async function getUser(req, res, next) {
    let user;
    try {
        user = await User.findById(req.params.id);
        if (user == null) {
            return res.status(404).json({ message: 'Usuário não encontrado' });
        }
    } catch (err) {
        return res.status(500).json({ message: err.message });
    }

    res.user = user;
    next();
}

// Rota para atualizar um usuário pelo ID
router.patch('/:id', getUser, async (req, res) => {
    if (req.body.nome != null) {
        res.user.nome = req.body.nome;
    }
    if (req.body.email != null) {
        res.user.email = req.body.email;
    }
    if (req.body.senha != null) {
        res.user.senha = await bcrypt.hash(req.body.senha, 10); // Hashing a nova senha antes de salvar
    }

    try {
        const updatedUser = await res.user.save();
        res.json(updatedUser);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

// Rota para excluir um usuário pelo ID
router.delete('/:id', async (req, res) => {
    try {
        const user = await User.findByIdAndDelete(req.params.id);
        if (user == null) {
            return res.status(404).json({ message: 'Usuário não encontrado' });
        }
        res.json({ message: 'Usuário deletado com sucesso' });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

// Rota para login de usuário
router.post('/login', async (req, res) => {
    const { email, senha } = req.body;

    try {
        // Encontrar o usuário pelo email
        const user = await User.findOne({ email: email });
        if (!user) {
            return res.status(404).json({ message: 'Usuário não encontrado' });
        }

        // Comparar a senha fornecida com a senha armazenada
        const isMatch = await bcrypt.compare(senha, user.senha);
        if (!isMatch) {
            return res.status(400).json({ message: 'Senha incorreta' });
        }

        // Gerar um token JWT (opcional)
        const token = jwt.sign({ id: user._id }, 'seu_segredo', { expiresIn: '1h' });

        res.json({ message: 'Login bem-sucedido', token: token });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

module.exports = router;
