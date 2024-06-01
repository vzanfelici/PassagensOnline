const mongoose = require('mongoose');

const passagemSchema = new mongoose.Schema({
    origem: String,
    destino: String,
    dataPartida: Date,
    dataChegada: Date,
    preco: Number
});

const Passagem = mongoose.model('Passagem', passagemSchema);

module.exports = Passagem;
