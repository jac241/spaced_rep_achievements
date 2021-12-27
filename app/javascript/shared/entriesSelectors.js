import { createSelector } from "@reduxjs/toolkit"

const minDate = new Date("1995-12-17T03:24:00")

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

export const compareDates = (a, b) => a.getTime() === b.getTime()

const selectEntries = (state) => state.entries

export const selectEntryEntities = (state) =>
  Object.values(state.entries.entities)

export const selectChaseModeConfig = (state) =>
  Object.values(state.api.chaseModeConfig)[0]

export const selectMemberships = (state) => Object.values(state.api.membership)

export const selectFilteredEntries = createSelector(
  [selectEntries, selectChaseModeConfig, selectMemberships],
  (entries, chaseModeConfig, memberships) => {
    let resultEntries = entries
    if (chaseModeConfig?.attributes?.onlyShowActiveUsers) {
      resultEntries = inactiveUsersFiltered(resultEntries)
    }
    if (chaseModeConfig?.attributes?.groupIds?.length > 0) {
      resultEntries = excludedGroupsFiltered(
        chaseModeConfig.attributes.groupIds,
        memberships,
        resultEntries
      )
    }

    return resultEntries
  }
)

const inactiveUsersFiltered = (entries) => {
  const remainingEntryIds = new Set()
  const remainingEntryEntities = Object.fromEntries(
    Object.entries(entries.entities).filter(
      ([id, entry]) => entry.attributes.online
    )
  )

  Object.keys(remainingEntryEntities).forEach((id) => remainingEntryIds.add(id))
  const remainingSortedIds = entries.ids.filter((id) =>
    remainingEntryIds.has(id)
  )

  return {
    ids: remainingSortedIds,
    entities: remainingEntryEntities,
  }
}

const excludedGroupsFiltered = (groupIds, memberships, entries) => {
  const remainingMemberIds = new Set()
  memberships.forEach((membership) => {
    if (groupIds.includes(membership.relationships.group.data.id)) {
      remainingMemberIds.add(membership.relationships.member.data.id)
    }
  })

  const remainingEntryIds = new Set()

  const remainingEntryEntities = Object.fromEntries(
    Object.entries(entries.entities).filter(([id, entry]) =>
      remainingMemberIds.has(entry.relationships.user.data.id)
    )
  )

  Object.keys(remainingEntryEntities).forEach((id) => remainingEntryIds.add(id))
  const remainingSortedIds = entries.ids.filter((id) =>
    remainingEntryIds.has(id)
  )

  return {
    ids: remainingSortedIds,
    entities: remainingEntryEntities,
  }
}

export const selectFilteredEntryEntities = createSelector(
  selectFilteredEntries,
  (entries) => Object.values(entries.entities)
)
export const selectFilteredEntryIds = createSelector(
  selectFilteredEntries,
  (entries) => entries.ids
)

export const selectEntriesArePresent = createSelector(
  selectFilteredEntries,
  (entries) => entries.ids.length > 0
)

export const selectUserEntry = createSelector(
  [selectFilteredEntryEntities, (state, userId) => userId],
  (entities, userId) => {
    return entities.find((entry) => entry.relationships.user.data.id == userId)
  }
)

export const selectUserEntryIndex = createSelector(
  [selectFilteredEntryIds, (state, userEntry) => userEntry],
  (entryIds, userEntry) => entryIds.findIndex((id) => id === userEntry?.id)
)

export const selectRivalEntry = createSelector(
  [selectFilteredEntries, (state, userEntryIndex) => userEntryIndex],
  (entries, userEntryIndex) => {
    const rivalId = userEntryIndex >= 1 ? userEntryIndex - 1 : null
    return entries.entities[entries.ids[rivalId]]
  }
)

export const selectUserById = createSelector(
  [(state) => state.api.user, (state, userId) => userId],
  (users, userId) => (userId ? users[userId] : null)
)

export const selectGroupsById = (state) => state.api.group
