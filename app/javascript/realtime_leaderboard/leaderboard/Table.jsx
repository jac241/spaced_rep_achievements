import React, { useEffect } from "react"
import { useSelector } from "react-redux"
import { createSelector } from "reselect"

const selectEntryIds = createSelector(
  state => state.entries,
  entries => entries.ids
)

const selectEntry = (state, id) => state.entries.entities[id]
const selectEntryUser = (state, entry) => state.api.user[entry.relationships.user.data.id]

const EntryRow = ({ rank, entryId }) => {
  const entry = useSelector(state => selectEntry(state, entryId))
  const user = useSelector(state => selectEntryUser(state, entry))
  return (
    <tr>
      <th>{ rank }</th>
      <td>{ user.attributes.username }</td>
      <td>{ entry.attributes.score }</td>
    </tr>
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
