const express = require('express');
const router = express.Router();
const Passagem = require('../models/passagemModel');

// Rota para obter todas as passagens de ônibus
router.get('/', async (req, res) => {
    try {
        const passagens = await Passagem.find();
        res.json(passagens);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

// Rota para obter passagens filtradas por origem, destino e data de partida
router.get('/buscar', async (req, res) => {
    const { origem, destino, dataPartida } = req.query;
    const query = {};

    if (origem) {
        query.origem = origem;
    }
    if (destino) {
        query.destino = destino;
    }
    if (dataPartida) {
        query.dataPartida = { $gte: new Date(dataPartida) };
    }

    try {
        const passagens = await Passagem.find(query);
        res.json(passagens);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

// Rota para obter todas as cidades de origem
router.get('/origens', async (req, res) => {
    try {
        const origens = await Passagem.distinct('origem');
        res.json(origens);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

// Rota para obter todas as cidades de destino
router.get('/destinos', async (req, res) => {
    try {
        const destinos = await Passagem.distinct('destino');
        res.json(destinos);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

// Rota para obter uma passagem de ônibus pelo ID
router.get('/:id', getPassagem, (req, res) => {
    res.json(res.passagem);
});

// Middleware para obter uma passagem de ônibus pelo ID
async function getPassagem(req, res, next) {
    let passagem;
    try {
        passagem = await Passagem.findById(req.params.id);
        if (passagem == null) {
            return res.status(404).json({ message: 'Passagem não encontrada' });
        }
    } catch (err) {
        return res.status(500).json({ message: err.message });
    }

    res.passagem = passagem;
    next();
}

// Rota para criar uma nova passagem de ônibus
router.post('/', async (req, res) => {
    const passagem = new Passagem({
        origem: req.body.origem,
        destino: req.body.destino,
        dataPartida: req.body.dataPartida,
        dataChegada: req.body.dataChegada,
        preco: req.body.preco
    });

    try {
        const novaPassagem = await passagem.save();
        res.status(201).json(novaPassagem);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

// Rota para atualizar uma passagem de ônibus pelo ID
router.patch('/:id', getPassagem, async (req, res) => {
    if (req.body.origem != null) {
        res.passagem.origem = req.body.origem;
    }
    if (req.body.destino != null) {
        res.passagem.destino = req.body.destino;
    }
    if (req.body.dataPartida != null) {
        res.passagem.dataPartida = req.body.dataPartida;
    }
    if (req.body.dataChegada != null) {
        res.passagem.dataChegada = req.body.dataChegada;
    }
    if (req.body.preco != null) {
        res.passagem.preco = req.body.preco;
    }
    try {
        const updatedPassagem = await res.passagem.save();
        res.json(updatedPassagem);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

// Rota para excluir uma passagem de ônibus pelo ID
router.delete('/:id', async (req, res) => {
    try {
        const passagem = await Passagem.findByIdAndDelete(req.params.id);
        if (passagem == null) {
            return res.status(404).json({ message: 'Passagem não encontrada' });
        }
        res.json({ message: 'Passagem deletada com sucesso' });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

module.exports = router;
