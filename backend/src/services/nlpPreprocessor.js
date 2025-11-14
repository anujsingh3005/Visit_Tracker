module.exports = function preprocessQuery(query) {
  const lower = query.toLowerCase();

  // Date handling
  const ranges = {};
  const today = new Date();

  if (lower.includes("last month")) {
    const start = new Date(today.getFullYear(), today.getMonth() - 1, 1);
    const end = new Date(today.getFullYear(), today.getMonth(), 1);
    ranges.dateRange = { start, end };
  }

  if (lower.includes("this month")) {
    const start = new Date(today.getFullYear(), today.getMonth(), 1);
    ranges.dateRange = { start, end: today };
  }

  if (lower.includes("last week")) {
    const start = new Date(today - 7 * 24 * 60 * 60 * 1000);
    ranges.dateRange = { start, end: today };
  }

  return { query, ...ranges };
};
