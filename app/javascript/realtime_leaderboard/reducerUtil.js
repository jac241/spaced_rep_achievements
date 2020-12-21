export const upsertIfUpdated = (state, entityAdapter, incomingEntity) => {
  const existing = state.entities[incomingEntity.id]

  if (existing === undefined) {
    entityAdapter.upsertOne(state, incomingEntity)
  } else if (new Date(incomingEntity.attributes.updatedAt) > new Date(existing.attributes.updatedAt)) {
    entityAdapter.upsertOne(state, incomingEntity)
  }
}
