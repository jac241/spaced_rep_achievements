export const upsertIfUpdated = (state, entityAdapter, incomingEntity) => {
  const existing = state.entities[incomingEntity.id]

  if (existing === undefined) {
    entityAdapter.upsertOne(state, incomingEntity)
  } else if (new Date(incomingEntity.attributes.updatedAt) > new Date(existing.attributes.updatedAt)) {
    console.log("newer, upserting")
    entityAdapter.upsertOne(state, incomingEntity)
  }
}
