const minDate = new Date('1995-12-17T03:24:00')

export const findMostRecentEntryUpdatedAt = (state) => {
  let max = minDate
  Object.values(state.entries.entities).forEach((entry) => {
    const updatedAt = new Date(entry.attributes.updatedAt)
    if (updatedAt > max) {
      max = updatedAt
    }
  })
  return max
}

export const compareDates = (a, b) => (
  a.getTime() === b.getTime()
)

