import React from "react"
import { fetchChaseModeConfig, initializeChaseMode } from "../actions";
import { useDispatch, useSelector } from "react-redux";
import { useEffect } from "preact/compat";
import { TailSpin } from "svg-loaders-react/src/svg-loader-components/tail-spin";

const SettingsForm = () => {
    const dispatch = useDispatch()
    const isRequesting = useSelector(state => state.chaseModeConfig.isRequestingChaseModeConfig)
    const chaseModeConfigsById = useSelector(state => state.api.chaseModeConfig)

    useEffect(() => {
        dispatch(fetchChaseModeConfig())
    }, [])
    if (isRequesting || theresNoConfig(chaseModeConfigsById)) {
        return <div>
           <TailSpin />
        </div>
    }
    return <form id="chase_mode_settings">
        <label>
            Only show active rivals?
            <input
                id="chase_mode_settings_only_show_active_users"
                name="chase_mode_settings[only_show_active_users]"
                type="checkbox"
                value={false}
            />
        </label>
    </form>
}

const theresNoConfig = (chaseModeConfigsById) => {
    return Object.keys(chaseModeConfigsById).length === 0
}

export default SettingsForm
