import React, { useEffect } from "react"
import { useDispatch } from "react-redux"
import { hydrate } from '../leaderboard/apiSlice'
import Table from '../leaderboard/Table'

const App = ({ initialData }) => {
  const dispatch = useDispatch()

  useEffect(() => {
  }, [])

  return (
    <div>
      <Table />
    </div>
  )
}

export default App
