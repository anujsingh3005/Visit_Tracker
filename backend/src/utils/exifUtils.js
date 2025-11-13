const exifr = require('exifr');

exports.extractExifData = async (buffer) => {
  try {
    const exif = await exifr.parse(buffer, { gps: true });
    return {
      timestamp: exif?.CreateDate || exif?.DateTimeOriginal || null,
      lat: exif?.latitude || null,
      long: exif?.longitude || null,
    };
  } catch (err) {
    return { timestamp: null, lat: null, long: null };
  }
};

exports.softValidate = (clientGps, exif) => {
  const flags = [];

  // GPS mismatch
  if (exif.lat && exif.long) {
    const distance = Math.sqrt(
      Math.pow(clientGps.lat - exif.lat, 2) +
      Math.pow(clientGps.long - exif.long, 2)
    );

    if (distance > 0.02) { // approx 2km
      flags.push('gps-mismatch');
    }
  }

  // Timestamp mismatch
  const serverTime = new Date();
  if (exif.timestamp) {
    const diffMs = Math.abs(serverTime - exif.timestamp);
    if (diffMs > 5 * 60 * 1000) { // >5 min difference
      flags.push('time-mismatch');
    }
  }

  return flags;
};
