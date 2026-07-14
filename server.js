import express from "express";
import ollama from "ollama";
//Ollamaとブラウザをつなげるためのパッケージ

const app = express();

app.use(express.static("public"));
app.use(express.json());

app.post("/api/chat", async (req, res) => {
    try {
        res.setHeader("Content-Type", "text/plain; charset=utf-8");
        res.setHeader("Transfer-Encoding", "chunked");

        const stream = await ollama.chat({
            model: "qwen2.5:1.5b",
            messages: req.body.messages,
            stream: true
        });

        for await (const part of stream) {
            res.write(part.message.content);
        }

        res.end();

    } catch (err) {
        console.error(err);
        res.status(500).end(err.message);
    }
});

app.listen(3000, () => {
    console.log("Server running: http://localhost:3000");
});