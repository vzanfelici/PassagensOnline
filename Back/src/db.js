const mongoose = require('mongoose');

mongoose.connect('mongodb://localhost:27017/nome-do-seu-banco-de-dados', {
    useNewUrlParser: true,
    useUnifiedTopology: true
}).then(() => {
    console.log("Conexão bem-sucedida com o MongoDB");
}).catch((error) => {
    console.log("Erro ao conectar ao MongoDB:", error);
});