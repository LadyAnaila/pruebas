require("dotenv").config();
const express = require("express");
const { Pool } = require("pg");
const cors = require("cors");
const jwt = require("jsonwebtoken");

const app = express();

// Configurar CORS para permitir todas las solicitudes (solo para desarrollo)
app.use(cors());
app.use(express.json());

// Configuración de la conexión a PostgreSQL
const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASS,
    port: process.env.DB_PORT
});

pool.connect()
    .then(() => console.log("✅ Conectado a PostgreSQL"))
    .catch(err => console.error("❌ Error conectando a PostgreSQL:", err));

// Login de usuario
app.post('/login', async (req, res) => {
    const { username, password } = req.body;

    try {
        const result = await pool.query('SELECT * FROM users WHERE username = $1', [username]);
        if (result.rows.length === 0) {
            return res.status(401).json({ error: 'Credenciales inválidas' });
        }

        const user = result.rows[0];
        if (user.password !== password) {
            return res.status(401).json({ error: 'Credenciales inválidas' });
        }

        // Generar un token JWT con el username
        const token = jwt.sign({ username: user.username }, process.env.JWT_SECRET, { expiresIn: '1h' });
        res.json({ token });
    } catch (err) {
        console.error('❌ Error en el login:', err);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Registro de usuario
app.post("/register", async (req, res) => {
    const { username, email, password } = req.body;

    try {
        const result = await pool.query(
            "INSERT INTO users (username, email, password) VALUES ($1, $2, $3) RETURNING *",
            [username, email, password]
        );
        res.status(201).json(result.rows[0]);
    } catch (err) {
        console.error("❌ Error al registrar usuario:", err);
        res.status(500).json({ error: "Error al registrar usuario." });
    }
});

// Obtener el perfil del usuario
app.get('/profile', async (req, res) => {
    const authHeader = req.headers['authorization'];
    console.log('Authorization Header:', authHeader); // Depuración

    const token = authHeader && authHeader.split(' ')[1];
    if (!token) {
        console.log('Token no proporcionado');
        return res.status(401).json({ error: 'No autorizado' });
    }

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        console.log('Token Decoded:', decoded); // Depuración

        const username = decoded.username;
        console.log('Username:', username); // Depuración

        // Consultar la base de datos utilizando el username
        const result = await pool.query('SELECT username, email, bio FROM users WHERE username = $1', [username]);
        console.log('Query Result:', result.rows); // Depuración

        if (result.rows.length === 0) {
            console.log('Usuario no encontrado');
            return res.status(404).json({ error: 'Usuario no encontrado' });
        }

        res.json(result.rows[0]);
    } catch (err) {
        console.error('❌ Error al obtener el perfil:', err);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Iniciar el servidor
app.listen(5000, () => {
    console.log("🚀 Servidor corriendo en http://localhost:5000");
});