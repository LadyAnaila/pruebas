const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const { Client } = require('pg');

// Configurar dotenv para usar variables de entorno
dotenv.config();

// Crear una instancia de la aplicación Express
const app = express();
const port = process.env.PORT || 5000;


// Middleware
app.use(cors({
  origin: ['https://mi-frontend.onrender.com'], 
  credentials: true
}));

// Configuración de la base de datos PostgreSQL
const client = new Client({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
});

// Conectar a la base de datos
client.connect()
  .then(() => console.log('Conexión exitosa a la base de datos'))
  .catch(err => console.error('Error de conexión a la base de datos:', err));


// Middleware para autenticar el token
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'No autorizado' });
  }

  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ error: 'Token inválido o expirado' });
    }

    if (!user.username) {
      return res.status(400).json({ error: 'El token no contiene un nombre de usuario válido.' });
    }

    req.user = user;
    next();
  });



};
//////////////////////////////////////////
//////////////////USER////////////////////
//////////////////////////////////////////

// Registro de usuario
app.post('/users/register', async (req, res) => {
  const { name, username, email, password, role } = req.body;

  if (!name || !username || !email || !password || !role) {
    return res.status(400).json({ error: 'Todos los campos son requeridos.' });
  }

  if (!['player', 'store'].includes(role)) {
    return res.status(400).json({ error: 'El rol debe ser "player" o "store".' });
  }

  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    const query = `
      INSERT INTO users (name, username, email, password, role)
      VALUES ($1, $2, $3, $4, $5)
    `;
    const values = [name, username, email, hashedPassword, role];
    await client.query(query, values);

    res.status(201).json({ message: 'Usuario registrado con éxito' });
  } catch (error) {
    console.error('Error al registrar usuario:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Inicio de sesión
app.post('/users/login', async (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({ error: 'Todos los campos son requeridos.' });
  }

  try {
    const query = `SELECT * FROM users WHERE username = $1`;
    const values = [username];
    const result = await client.query(query, values);

    if (result.rows.length === 0) {
      return res.status(401).json({ error: 'Credenciales inválidas.' });
    }

    const user = result.rows[0];
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(401).json({ error: 'Credenciales inválidas.' });
    }

    const token = jwt.sign(
      { username: user.username, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );

    // Incluye el username y el role en la respuesta
    res.status(200).json({ message: 'Inicio de sesión correcto', token, username: user.username, role: user.role });
  } catch (error) {
    console.error('Error al iniciar sesión:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});


// Obtener perfil del usuario
app.get('/users/profile', authenticateToken, async (req, res) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'No autorizado' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const username = decoded.username;

    const query = `SELECT name, username, email, role FROM users WHERE username = $1`;
    const values = [username];
    const result = await client.query(query, values);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error al obtener el perfil del usuario:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});
app.put('/users/profile', async (req, res) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'No autorizado' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const username = decoded.username;
    const { email, bio } = req.body;

    if (!email) {
      return res.status(400).json({ error: 'El campo email es obligatorio.' });
    }


    // Construir la consulta dinámicamente para incluir bio solo si está presente
    let query = `
      UPDATE users
      SET email = $1
    `;
    const values = [email];

    if (bio) {
      query += `, bio = $2`;
      values.push(bio);
    }

    query += ` WHERE username = $${values.length + 1}`;
    values.push(username);

    await client.query(query, values);

    res.status(200).json({ message: 'Perfil actualizado con éxito' });
  } catch (error) {
    console.error('Error al actualizar perfil:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

///////////////////////////////////////////
////////////////////EVENTS/////////////////
//////////////////////////////////////////


// Crear un nuevo evento
app.post('/api/events', authenticateToken, async (req, res) => {
  const { username } = req.user; // Usuario autenticado
  const {
    name,
    description,
    date,
    address,
    game_name,
    format,
    event_type,
    start_time,
    registration_fee,
    max_participants,
    visibility,
    image_url,
    duration,
    contact_info,
    age_restriction,
    languages,
    cancellation_policy,
    internal_notes,
  } = req.body;

  if (!name || !description || !date || !address || !game_name || !event_type || !start_time) {
    return res.status(400).json({ error: 'Faltan campos obligatorios' });
  }

  try {
    const query = `
      INSERT INTO events (
        name, description, date, address, game_name, format, event_type, start_time,
        registration_fee, max_participants, visibility, image_url, duration, contact_info,
        age_restriction, languages, cancellation_policy, internal_notes, created_by
      )
      VALUES (
        $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19
      )
      RETURNING *
    `;
    const values = [
      name, description, date, address, game_name, format, event_type, start_time,
      registration_fee, max_participants, visibility, image_url, duration, contact_info,
      age_restriction, languages, cancellation_policy, internal_notes, username,
    ];
    const result = await client.query(query, values);

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error al crear el evento:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Obtener todos los eventos 
app.get('/api/events', async (req, res) => {
  try {
    const query = `
      SELECT id, name, description, date, address, created_by, game_name, event_type
      FROM events
      ORDER BY date DESC
    `;
    const result = await client.query(query);

    res.json(result.rows);
  } catch (error) {
    console.error('Error al obtener eventos:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Obtener eventos creados por el usuario autenticado
app.get('/api/events/created', authenticateToken, async (req, res) => {
  const { username } = req.user;

  if (!username) {
    return res.status(400).json({ error: 'Nombre de usuario no proporcionado.' });
  }

  try {
    const query = `
      SELECT * 
      FROM events
      WHERE created_by = $1
    `;
    const values = [username];
    const result = await client.query(query, values);

    res.json(result.rows);
  } catch (error) {
    console.error('Error al obtener eventos creados:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Obtener eventos en los que el usuario está inscrito
app.get('/api/events/registered', authenticateToken, async (req, res) => {
  const { username } = req.user;

  try {
    const query = `
      SELECT e.id, e.name, e.description, e.date, e.address
      FROM events e
      INNER JOIN event_participants ep ON e.id = ep.event_id
      WHERE ep.username = $1
      ORDER BY e.date DESC
    `;
    const values = [username];
    const result = await client.query(query, values);

    res.json(result.rows);
  } catch (error) {
    console.error('Error al obtener eventos inscritos:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Obtener eventos creados por el usuario autenticado (si usas esta ruta)
app.get('/api/my-events', authenticateToken, async (req, res) => {
  const { username } = req.user;

  try {
    const query = `
      SELECT id, name, description, date, address
      FROM events
      WHERE created_by = $1
      ORDER BY date DESC
    `;
    const values = [username];
    const result = await client.query(query, values);

    res.json(result.rows);
  } catch (error) {
    console.error('Error al obtener eventos del usuario:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Obtener los datos de un evento por ID (detalle del evento)
app.get('/api/events/:id', async (req, res) => {
    const { id } = req.params;
  if (!id || isNaN(id)) {
    return res.status(400).json({ error: 'ID del evento no válido.' });
  }

  try {
    const eventQuery = `
      SELECT e.id, e.name, e.description, e.date, e.address, e.max_participants,
        e.game_name, e.format, e.event_type, e.start_time, e.registration_fee,
        e.visibility, e.image_url, e.duration, e.contact_info, e.age_restriction,
        e.languages, e.cancellation_policy, e.internal_notes, e.created_by,
        COALESCE((
          SELECT json_agg(username)
          FROM event_participants
          WHERE event_id = $1
        ), '[]') AS participants
      FROM events e
      WHERE e.id = $1
    `;
    const values = [id];
    const result = await client.query(eventQuery, values);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Evento no encontrado' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error al obtener el evento:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Modificar un evento
app.put('/api/events/:id', authenticateToken, async (req, res) => {
  const { username } = req.user;
  const { id } = req.params;
  const { name, description, date, address, game_name, event_type, start_time } = req.body;

  if (!name || !date || !address || !game_name || !event_type || !start_time) {
    return res.status(400).json({ error: 'Faltan campos obligatorios' });
  }
  try {
    const query = `
      UPDATE events
      SET name = $1, description = $2, date = $3, address = $4, game_name = $5, event_type = $6, start_time = $7
      WHERE id = $8 AND created_by = $9
    `;
    const values = [name, description, date, address, game_name, event_type, start_time, id, username];
    const result = await client.query(query, values);

    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Evento no encontrado o no autorizado.' });
    }

    res.status(200).json({ message: 'Evento actualizado con éxito' });
  } catch (error) {
    console.error('Error al actualizar evento:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Eliminar un evento
app.delete('/api/events/:id', authenticateToken, async (req, res) => {
  const { id } = req.params;
  const { username } = req.user;

  if (!id || isNaN(id)) return res.status(400).json({ error: 'ID inválido.' });

  try {
    const result = await client.query('DELETE FROM events WHERE id = $1 AND created_by = $2', [id, username]);
    if (result.rowCount === 0) return res.status(404).json({ error: 'Evento no encontrado o no autorizado.' });

    res.status(200).json({ message: 'Evento eliminado con éxito.' });
  } catch (error) {
    console.error('Error al eliminar evento:', error);
    res.status(500).json({ error: 'Error interno del servidor.' });
  }
});

// Inscribirse en un evento
app.post('/api/events/:id/register', authenticateToken, async (req, res) => {
  const { id } = req.params;
  const { username } = req.user;

  if (!id || isNaN(id)) {
    return res.status(400).json({ error: 'ID del evento no válido.' });
  }

  try {
    const eventQuery = `
      SELECT max_participants, (
        SELECT COUNT(*) FROM event_participants WHERE event_id = $1
      ) AS current_participants
      FROM events
      WHERE id = $1
    `;
    const eventResult = await client.query(eventQuery, [id]);

    if (eventResult.rows.length === 0) {
      return res.status(404).json({ error: 'El evento no existe.' });
    }

    const { max_participants, current_participants } = eventResult.rows[0];
    if (max_participants && current_participants >= max_participants) {
      return res.status(400).json({ error: 'El evento ya alcanzó el límite de participantes.' });
    }

    const insertQuery = `
      INSERT INTO event_participants (event_id, username)
      VALUES ($1, $2)
      ON CONFLICT (event_id, username) DO NOTHING
    `;
    await client.query(insertQuery, [id, username]);

    res.status(200).json({ message: 'Inscripción exitosa' });
  } catch (error) {
    console.error('Error al inscribirse al evento:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Cancelar inscripción
app.delete('/api/events/:id/unregister', authenticateToken, async (req, res) => {
  const { id } = req.params;
  const { username } = req.user;

  if (!id || isNaN(id)) return res.status(400).json({ error: 'ID inválido.' });

  try {
    const result = await client.query('DELETE FROM event_participants WHERE event_id = $1 AND username = $2', [id, username]);
    if (result.rowCount === 0) return res.status(404).json({ error: 'No estás inscrito en este evento.' });

    res.status(200).json({ message: 'Inscripción cancelada con éxito.' });
  } catch (error) {
    console.error('Error al cancelar la inscripción:', error);
    res.status(500).json({ error: 'Error interno del servidor.' });
  }
});

// Listar participantes de un evento
app.get('/api/events/:id/participants', authenticateToken, async (req, res) => {
  const { id } = req.params;
  const { role, username } = req.user;

  try {
    // Comprueba si el usuario es organizador o creador del evento
    const eventResult = await client.query(
      'SELECT created_by FROM events WHERE id = $1',
      [id]
    );
    if (eventResult.rows.length === 0) {
      return res.status(404).json({ error: 'Evento no encontrado.' });
    }
    const createdBy = eventResult.rows[0].created_by;
    if (role !== 'store' && username !== createdBy) {
      return res.status(403).json({ error: 'No autorizado.' });
    }

    // Devuelve la lista de participantes
    const result = await client.query(
      `SELECT u.id, u.name, u.email
       FROM event_participants ep
       JOIN users u ON ep.username = u.username
       WHERE ep.event_id = $1`,
      [id]
    );
    res.json(result.rows);
  } catch (error) {
    console.error('Error al obtener participantes:', error);
    res.status(500).json({ error: 'Error interno del servidor.' });
  }
});

// Obtener historial de participación de un usuario
app.get('/api/users/:username/history', authenticateToken, async (req, res) => {
  const { username } = req.params;
  try {
    const query = `
      SELECT e.id, e.name, e.date, e.game_name, e.event_type, e.tournament_type, tr.position, tr.points
      FROM events e
      JOIN event_participants ep ON e.id = ep.event_id
      LEFT JOIN tournament_rankings tr ON tr.tournament_id = e.id AND tr.username = ep.username
      WHERE ep.username = $1
      ORDER BY e.date DESC
    `;
    const result = await client.query(query, [username]);
    res.json(result.rows);
  } catch (error) {
    console.error('Error al obtener historial:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});


// Obtener logros de un usuario
app.get('/api/users/:username/achievements', authenticateToken, async (req, res) => {
  const { username } = req.params;
  try {
    const query = `
      SELECT a.id, a.name, a.description, ua.date_earned
      FROM user_achievements ua
      JOIN achievements a ON ua.achievement_id = a.id
      WHERE ua.username = $1
      ORDER BY ua.date_earned DESC
    `;
    const result = await client.query(query, [username]);
    res.json(result.rows);
  } catch (error) {
    console.error('Error al obtener logros:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Obtener ranking de un usuario en un torneo
app.get('/api/tournaments/:id/ranking', authenticateToken, async (req, res) => {
  const { id } = req.params;
  try {
    const query = `
      SELECT tr.username, u.name, tr.position, tr.points
      FROM tournament_rankings tr
      JOIN users u ON tr.username = u.username
      WHERE tr.tournament_id = $1
      ORDER BY tr.position ASC
    `;
    const result = await client.query(query, [id]);
    res.json(result.rows);
  } catch (error) {
    console.error('Error al obtener ranking:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

//////////////////////////
////Resultados torneos////
//////////////////////////



// Crear o actualizar una ronda eliminatoria
app.post('/api/events/:id/elimination-round', authenticateToken, async (req, res) => {
  const { id } = req.params;
  const { round_number, pairings } = req.body;

  if (!round_number || !Array.isArray(pairings)) {
    return res.status(400).json({ error: 'Datos de ronda incompletos.' });
  }

  try {
    // Puedes actualizar si ya existe, o insertar si es nueva
    await client.query(
      `INSERT INTO elimination_rounds (event_id, round_number, pairings)
       VALUES ($1, $2, $3)
       ON CONFLICT (event_id, round_number) DO UPDATE SET pairings = $3`,
      [id, round_number, JSON.stringify(pairings)]
    );
    res.status(200).json({ message: 'Ronda guardada.' });
  } catch (error) {
    console.error('Error al guardar ronda eliminatoria:', error);
    res.status(500).json({ error: 'Error interno del servidor.' });
  }
});




// Guardar resultados finales de un torneo
app.post('/api/events/:id/results', authenticateToken, async (req, res) => {
  const { id } = req.params;
  const { results } = req.body;

  if (!Array.isArray(results) || results.length === 0) {
    return res.status(400).json({ error: 'Resultados no válidos.' });
  }

  try {
    await client.query(
      `INSERT INTO tournament_results (event_id, results)
       VALUES ($1, $2)
       ON CONFLICT (event_id) DO UPDATE SET results = $2, created_at = NOW()`,
      [id, JSON.stringify(results)]
    );
    res.status(200).json({ message: 'Resultados guardados.' });
  } catch (error) {
    console.error('Error al guardar resultados del torneo:', error);
    res.status(500).json({ error: 'Error interno del servidor.' });
  }
});




// Obtener resultados finales de un torneo
app.get('/api/events/:id/results', authenticateToken, async (req, res) => {
  const { id } = req.params;
  try {
    const result = await client.query(
      `SELECT results FROM tournament_results WHERE event_id = $1`,
      [id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'No hay resultados para este torneo.' });
    }
    res.json(result.rows[0].results);
  } catch (error) {
    console.error('Error al obtener resultados del torneo:', error);
    res.status(500).json({ error: 'Error interno del servidor.' });
  }
});
//////////////////////////
//////// Decks////////////
//////////////////////////


// Crear un nuevo mazo
app.post('/decks', authenticateToken, async (req, res) => {
  const { name, cards } = req.body;
  const { username } = req.user;
  if (!name || !Array.isArray(cards) || cards.length === 0) {
    return res.status(400).json({ error: 'Nombre y cartas son requeridos.' });
  }
  try {
    const userResult = await client.query('SELECT id FROM users WHERE username = $1', [username]);
    if (userResult.rows.length === 0) return res.status(404).json({ error: 'Usuario no encontrado.' });
    const user_id = userResult.rows[0].id;
    const deckResult = await client.query(
      'INSERT INTO decks (user_id, name) VALUES ($1, $2) RETURNING id',
      [user_id, name]
    );
    const deck_id = deckResult.rows[0].id;
    for (const card of cards) {
      await client.query(
        'INSERT INTO deck_cards (deck_id, card_code, quantity) VALUES ($1, $2, $3)',
        [deck_id, card.card_code, card.quantity]
      );
    }
    res.status(201).json({ message: 'Mazo guardado con éxito', deck_id });
  } catch (error) {
    res.status(500).json({ error: 'Error interno del servidor.' });
  }
});

// Obtener todos los mazos del usuario autenticado
app.get('/decks', authenticateToken, async (req, res) => {
  const { username } = req.user;
  try {
    const userResult = await client.query('SELECT id FROM users WHERE username = $1', [username]);
    if (userResult.rows.length === 0) return res.status(404).json({ error: 'Usuario no encontrado.' });
    const user_id = userResult.rows[0].id;
    const decksResult = await client.query(
      'SELECT id, name, created_at FROM decks WHERE user_id = $1 ORDER BY created_at DESC',
      [user_id]
    );
    res.json(decksResult.rows);
  } catch (error) {
    res.status(500).json({ error: 'Error interno del servidor.' });
  }
});


// Obtener info de un mazo concreto
app.get('/decks/:deck_id', authenticateToken, async (req, res) => {
  const { deck_id } = req.params;
  const { username } = req.user;
  try {
    const result = await client.query(
      `SELECT d.id, d.name, d.created_at
       FROM decks d
       JOIN users u ON d.user_id = u.id
       WHERE d.id = $1 AND u.username = $2`,
      [deck_id, username]
    );
    if (result.rows.length === 0) return res.status(404).json({ error: 'Mazo no encontrado o no autorizado.' });
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: 'Error interno del servidor.' });
  }
});

// Obtener las cartas de un mazo concreto
app.get('/decks/:deck_id/cards', authenticateToken, async (req, res) => {
  const { deck_id } = req.params;
  const { username } = req.user;
  try {
    const deckResult = await client.query(
      `SELECT d.id FROM decks d
       JOIN users u ON d.user_id = u.id
       WHERE d.id = $1 AND u.username = $2`,
      [deck_id, username]
    );
    if (deckResult.rows.length === 0) return res.status(404).json({ error: 'Mazo no encontrado o no autorizado.' });
    const cardsResult = await client.query(
      'SELECT card_code, quantity FROM deck_cards WHERE deck_id = $1',
      [deck_id]
    );
    res.json(cardsResult.rows);
  } catch (error) {
    res.status(500).json({ error: 'Error interno del servidor.' });
  }
});

// Modificar un mazo
app.put('/decks/:deck_id', authenticateToken, async (req, res) => {
  const { deck_id } = req.params;
  const { name, cards } = req.body;
  const { username } = req.user;
  try {
    const deckResult = await client.query(
      `SELECT d.id FROM decks d
       JOIN users u ON d.user_id = u.id
       WHERE d.id = $1 AND u.username = $2`,
      [deck_id, username]
    );
    if (deckResult.rows.length === 0) return res.status(404).json({ error: 'Mazo no encontrado o no autorizado.' });

    // Actualiza el nombre
    await client.query('UPDATE decks SET name = $1 WHERE id = $2', [name, deck_id]);
    // Borra las cartas
    await client.query('DELETE FROM deck_cards WHERE deck_id = $1', [deck_id]);
    // Añadir cartas
    for (const card of cards) {
      await client.query(
        'INSERT INTO deck_cards (deck_id, card_code, quantity) VALUES ($1, $2, $3)',
        [deck_id, card.card_code, card.quantity]
      );
    }
    res.json({ message: 'Mazo actualizado' });
  } catch (error) {
    res.status(500).json({ error: 'Error interno del servidor.' });
  }
});

// Eliminar un mazo
app.delete('/decks/:deck_id', authenticateToken, async (req, res) => {
  const { deck_id } = req.params;
  const { username } = req.user;

  try {
    // Comprueba que el mazo pertenece al usuario
    const deckResult = await client.query(
      `SELECT d.id FROM decks d
       JOIN users u ON d.user_id = u.id
       WHERE d.id = $1 AND u.username = $2`,
      [deck_id, username]
    );
    if (deckResult.rows.length === 0) {
      return res.status(404).json({ error: 'Mazo no encontrado o no autorizado.' });
    }

    // Borra las cartas del mazo
    await client.query('DELETE FROM deck_cards WHERE deck_id = $1', [deck_id]);
    // Borra el mazo
    await client.query('DELETE FROM decks WHERE id = $1', [deck_id]);

    res.status(200).json({ message: 'Mazo eliminado con éxito.' });
  } catch (error) {
    console.error('Error al eliminar mazo:', error);
    res.status(500).json({ error: 'Error interno del servidor.' });
  }
});

//////////////////////////
// Iniciar el servidor///
//////////////////////////
app.listen(port, () => {
  console.log(` Servidor activo en http://localhost:${port}`);
});


