module.exports = function formatResult(rows, chart) {
  return {
    success: true,
    rows,
    columns: rows.length ? Object.keys(rows[0]) : [],
    chart
  };
};
