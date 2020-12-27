import React, { useEffect } from "react"
import { useDispatch } from "react-redux"
import { hydrate } from '../leaderboard/apiSlice'
import Table from '../leaderboard/Table'

const App = ({ controller }) => {
  const dispatch = useDispatch()

  useEffect(() => {
    controller.subscribeToLeaderboard()
  }, [])

  return (
    <Table />
  )
}

export default App
