// seed.js - creates demo manager and salesperson (uids match Flutter mock)
const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcrypt');

const prisma = new PrismaClient();

async function main() {
  const passHash = await bcrypt.hash('password123', 10);

  // Manager
  await prisma.user.upsert({
    where: { email: 'manager@test.com' },
    update: {},
    create: {
      uid: 'manager123',
      name: 'Alia Bhatt',
      email: 'manager@test.com',
      password: passHash,
      role: 'manager',
      phone: '+91 99887 76655',
      address: '456, Juhu, Mumbai',
      designation: 'Regional Manager',
      profileImageUrl: 'https://placehold.co/100x100/A9C27A/000000?text=AB'
    },
  });

  // Salesperson
  await prisma.user.upsert({
    where: { email: 'sales@test.com' },
    update: {},
    create: {
      uid: 'sales123',
      name: 'Anuj Sharma',
      email: 'sales@test.com',
      password: passHash,
      role: 'salesperson',
      phone: '+91 98765 43210',
      address: '123, Marine Drive, Mumbai',
      designation: 'Sales Executive',
      profileImageUrl: 'https://placehold.co/100x100/E6E6E6/000000?text=AS'
    },
  });

  console.log("Seed complete");
}

main()
  .catch(e => { console.error(e); process.exit(1); })
  .finally(async () => {
    await prisma.$disconnect();
  });
