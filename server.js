import express from "express";
import ollama from "ollama";
//Ollamaとブラウザをつなげるためのパッケージ

const app = express();

app.use(express.static("public"));
app.use(express.json());

app.post("/api/chat", async (req, res) => {
    try {
        const response = await ollama.chat({
            model: "qwen2.5:1.5b",
            messages: req.body.messages
        });

        res.json(response);

    } catch (err) {
        console.error(err);

        res.status(500).json({
            error: err.message
        });
    }
});

app.listen(3000, () => {
    console.log("Server running: http://localhost:3000");
});