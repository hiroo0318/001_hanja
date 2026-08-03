function splitParts(value: string) {
  return value.split("/").map((part) => part.trim()).filter(Boolean);
}

export function formatMeaningReading(meaning: string, reading: string) {
  const meanings = splitParts(meaning);
  const readings = splitParts(reading);
  const count = Math.max(meanings.length, readings.length);
  return Array.from({ length: count }, (_, index) => {
    const pairedMeaning = meanings[Math.min(index, meanings.length - 1)] ?? "";
    const pairedReading = readings[Math.min(index, readings.length - 1)] ?? "";
    return `${pairedMeaning} ${pairedReading}`.trim();
  }).join(" / ");
}
