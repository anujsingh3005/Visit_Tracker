const preprocess = require("../services/nlpPreprocessor");
const generateSQL = require("../services/llmSqlGenerator");
const validateSQL = require("../services/sqlValidator");
const executeSQL = require("../services/sqlExecutor");
const buildChart = require("../services/chartBuilder");
const format = require("../services/resultFormatter");

exports.query = async (req, res) => {
  try {
    const { query } = req.body;

    const pre = preprocess(query);
    const llmResult = await generateSQL(pre);

    let validatedSQL = validateSQL(llmResult.sql);
    const rows = await executeSQL(validatedSQL, llmResult.params || []);

    const chart = buildChart(llmResult.chart, rows);
    res.json(format(rows, chart));

  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};
