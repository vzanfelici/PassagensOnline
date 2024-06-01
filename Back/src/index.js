const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');


const passagemRoutes = require('./routes/passagemRoutes');
const userRoutes = require('./routes/userRoutes');

const app = express();
const PORT = process.env.PORT || 3000;
const MONGODB_URI = 'mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.2.6';

// Configurar CORS
app.use(cors());

// Middleware para processar solicitações JSON
app.use(express.json());

// Rotas para passagens de ônibus
app.use('/passagens', passagemRoutes);

// Rotas para usuários
app.use('/usuarios', userRoutes);

// Conexão com o banco de dados MongoDB
mongoose.connect(MONGODB_URI, { useNewUrlParser: true, useUnifiedTopology: true })
    .then(() => {
        console.log('Conexão bem-sucedida com o MongoDB');
        // Iniciar o servidor após a conexão bem-sucedida com o banco de dados
        app.listen(PORT, () => {
            console.log(`Servidor rodando na porta ${PORT}`);
        });
    })
    .catch((err) => {
        console.error('Erro ao conectar ao MongoDB:', err);
    });
