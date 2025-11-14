const groq = require("../utils/groqClient");

// SYSTEM PROMPT FOR SQL + CHART GENERATION
const SYSTEM_PROMPT = `
You generate SQL queries for a PostgreSQL database and also produce chart metadata.
ALWAYS respond with JSON format:

{
  "sql": "...",
  "params": [],
  "chart": {
     "type": "bar" | "line" | "pie" | null,
     "x": [],
     "y": [],
     "title": ""
  }
}

Rules:
- Only use SELECT queries. Never modify data.
- Use the following tables and columns:

TABLE: User
- id
- uid
- name
- role
- email

TABLE: Visit
- id
- salespersonId
- clientName
- status
- startTime
- endTime

If user asks "performance", "graph", "chart", "trend",
generate chart metadata based on the SQL result.
`;

module.exports = async function generateSQL(preprocessedQuery) {
  const userPrompt = `
User Query: ${preprocessedQuery.query}
Extracted Date Range: ${JSON.stringify(preprocessedQuery.dateRange || {})}

Generate SQL + visualization metadata.
  `;

  const completion = await groq.chat.completions.create({
    model: "llama-3.1-70b-versatile",
    response_format: { type: "json_object" },
    messages: [
      { role: "system", content: SYSTEM_PROMPT },
      { role: "user", content: userPrompt }
    ]
  });

  return JSON.parse(completion.choices[0].message.content);
};
