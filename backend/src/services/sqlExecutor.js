const prisma = require("../config/db");

module.exports = async function executeSQL(sql, params) {
  return prisma.$queryRawUnsafe(sql, ...params);
};
