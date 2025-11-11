const express = require('express');
const cors = require('cors');
const authRoutes = require('./routes/auth');
const visitRoutes = require('./routes/visits');

const app = express();

app.use(cors());
app.use(express.json());

app.use('/api/auth', authRoutes);
app.use('/api/visits', visitRoutes);

app.get('/', (req, res) => res.json({ ok: true, message: 'Visit Tracker API' }));

// error handler
app.use((err, req, res, next) => {
  console.error(err);
  res.status(err.status || 500).json({ error: err.message || 'Internal Server Error' });
});

module.exports = app;
