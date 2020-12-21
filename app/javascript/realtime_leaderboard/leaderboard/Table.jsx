import React, { useEffect } from "react"
import { useSelector } from "react-redux"
import { createSelector } from "reselect"
//import image from "images/medals/halo-3/double-kill.png"
const assets = require.context('../..', true)
assets.keys().forEach((filename)=>{
  console.log(filename);
});
const assetPath = (name) => assets(`.${name}`, true)



const selectEntryIds = createSelector(
  state => state.entries,
  entries => entries.ids
)

const selectEntry = (state, id) => state.entries.entities[id]
const selectEntryUser = (state, entry) => state.api.user[entry.relationships.user.data.id]

const ONLINE_INVERVAL = 5 * 60 * 1000

const EntryRow = ({ rank, entryId }) => {
  const entry = useSelector(state => selectEntry(state, entryId))
  const user = useSelector(state => selectEntryUser(state, entry))
  return (
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
  )
}

const selectTopMedalStatisticIdsForUser = (state, user) => {
  return state.topMedals.topMedalsbyUserId[user.id].slice(0, 5)
}

const selectTopMedals = (state, topMedalStatisticIds) => {
  const medalIds = topMedalStatisticIds.map(id => state.topMedals.entities[id].relationships.medal.data.id)
  return medalIds.map((id) => state.api.medal[id])
}

const selectMedalStatistics = (state, ids) => {
  return ids.map(id => state.topMedals.entities[id])
}

const TopMedalsList = ({ user }) => {
  const topMedalStatisticIds = useSelector(state => selectTopMedalStatisticIdsForUser (state, user))
  const medalStatistics = useSelector(state => selectMedalStatistics(state, topMedalStatisticIds))
  const topMedals = useSelector(state => selectTopMedals(state, topMedalStatisticIds))
  return (
    <div className="top-medals">
      {
        topMedals.map((medal, index) => (
          <TopMedal medal={medal} medalStatistic={medalStatistics[index]} key={medal.id} />
        ))
      }
    </div>
  )
}

const TopMedal = ({ medal, medalStatistic }) => {
  const medalsById = useSelector(state => state.api.medal)
  return (
    <div className="top-medal">
      <img src={assetPath(medal.attributes.imagePath)} width="28" height="28"></img>
      {' '}
      x
      { ` ${medalStatistic.attributes.count}` }

    </div>
  )
}

const Table = () => {
  const entryIds = useSelector(selectEntryIds)
  return (
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
  )
}

export default Table
