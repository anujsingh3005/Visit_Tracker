module.exports = function normalizeChart(chart, rows) {
  if (!chart || !chart.type) return null;

  // If LLM forgot x/y arrays, try simple fallback
  if (chart.type === "bar" && (!chart.x || !chart.y)) {
    return {
      type: "bar",
      title: chart.title || "Chart",
      x: rows.map(r => r.label || r.name || r.clientname || "Unknown"),
      y: rows.map(r => r.count || r.total || 1)
    };
  }

  return chart;
};
