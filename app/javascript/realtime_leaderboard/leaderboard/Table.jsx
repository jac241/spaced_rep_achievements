import React, { useEffect } from "react"
import { useSelector, shallowEqual } from "react-redux"
import { createSelector } from "reselect"

const assets = require.context('../..', true)
const assetPath = (name) => assets(`.${name}`, true)

const ONLINE_INVERVAL = 3 * 60 * 1000

const Table = () => {
  const entryIds = useSelector(selectEntryIdsWithPoints)
  const isRequestingCachedEntries = useSelector(selectIsRequestingCachedEntries)

  return (
    <div>
      <table className="table table-responsive-md">
        <thead>
          <tr>
            <th>Rank</th>
            <th>Username</th>
            <th>Score</th>
            <th>
              Top Scoring Medals
              <span className="float-right"><a href="/medals">Medal values</a></span>
            </th>
          </tr>
        </thead>
        <tbody>
          {
            entryIds.map((id, index) =>
              <EntryRow key={id} rank={index + 1} entryId={id} />
            )
          }
        </tbody>
      </table>
      {
        isRequestingCachedEntries && <Spinner />
      }
    </div>
  )
}

const selectEntryIds = state => state.entries.ids
const selectEntriesById = state => state.entries.entities

const selectEntryIdsWithPoints = createSelector(
  [ selectEntryIds, selectEntriesById ],
  ( entryIds, entriesById ) => entryIds.filter(id => entriesById[id].attributes.score > 0)
)

const selectIsRequestingCachedEntries = (state) => state.entries.isRequestingCachedEntries

const EntryRow = ({ rank, entryId }) => {
  const entry = useSelector(state => selectEntry(state, entryId))
  const user = useSelector(state => selectEntryUser(state, entry))
  return <Entry rank={rank} entry={entry} user={user} />
}

const Entry = React.memo(
  ({rank, entry, user}) => (
    <tr>
      <th>{ rank }</th>
      <td>{
        Date.now() - new Date(entry.attributes.updatedAt) < ONLINE_INVERVAL ?
          (
            <span
              className="text-primary"
              title="Online"
            >
              { user.attributes.username }
            </span>
          ) :
          user.attributes.username
      }</td>
      <td>{ entry.attributes.score }</td>
      <td>
        <TopMedalsList user={user} />
      </td>
    </tr>
  ),
  (prevProps, nextProps) => (
    prevProps.rank == nextProps.rank &&
    prevProps.entry.attributes.updatedAt == nextProps.entry.attributes.updatedAt &&
    prevProps.user.attributes.updatedAt == nextProps.entry.user.updatedAt
  )
)

const selectEntry = (state, id) => state.entries.entities[id]
const selectEntryUser = (state, entry) => state.api.user[entry.relationships.user.data.id]


const TopMedalsList = ({ user }) => {
  const topMedalStatisticIds = useSelector(state => selectTopMedalStatisticIdsForUser(state, user))
  const medalStatistics = useSelector(state => selectMedalStatistics(state, topMedalStatisticIds), shallowEqual)
  const topMedals = useSelector(state => selectTopMedals(state, topMedalStatisticIds), shallowEqual)

  return <TopMedals topMedals={topMedals} medalStatistics={medalStatistics} />
}

const selectTopMedalStatisticIdsForUser = (state, user) => {
  return state.topMedals.topMedalsbyUserId[user.id]
}

const selectMedalStatistics = (state, ids) => {
  return ids.map(id => state.topMedals.entities[id])
}

const selectTopMedals = (state, topMedalStatisticIds) => {
  const medalIds = topMedalStatisticIds.map(id => state.topMedals.entities[id].relationships.medal.data.id)
  return medalIds.map((id) => state.api.medal[id])
}

const TopMedals = React.memo(({ topMedals, medalStatistics }) => (
  <div className="top-medals">
    {
      topMedals.map((medal, index) => (
        <TopMedal medal={medal} medalStatistic={medalStatistics[index]} key={medal.id} />
      ))
    }
  </div>
))

const TopMedal = React.memo(({ medal, medalStatistic }) => {
  return (
    <div className="top-medal">
      <img src={assetPath(medal.attributes.imagePath)} width="28" height="28"></img>
      {' '}
      x
      { ` ${medalStatistic.attributes.count}` }

    </div>
  )
})

const Spinner = () => (
  <div class="d-flex justify-content-center">
    <div class="spinner-border" role="status">
      <span class="sr-only">Loading...</span>
    </div>
  </div>
)

export default Table
