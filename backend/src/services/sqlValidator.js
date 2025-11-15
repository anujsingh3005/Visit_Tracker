module.exports = function validateSQL(sql) {
  if (!sql.toLowerCase().startsWith("select")) {
    throw new Error("Only SELECT queries allowed");
  }

  if (sql.toLowerCase().includes("delete") ||
      sql.toLowerCase().includes("update") ||
      sql.toLowerCase().includes("insert")) {
    throw new Error("Modification queries not allowed");
  }

  if (!sql.toLowerCase().includes("limit")) {
    sql += " LIMIT 500";
  }

  return sql;
};
