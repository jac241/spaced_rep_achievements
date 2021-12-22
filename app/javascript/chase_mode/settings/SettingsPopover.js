import React from "react"
import { Popover, ArrowContainer } from 'react-tiny-popover'
import { useRef, useState } from "preact/compat";

import SettingsIcon from "../icons/settings.svg";
import SettingsForm from "./SettingsForm";

const SettingsPopover = () => {
    const [isPopoverOpen, setIsPopoverOpen] = useState(false)

    return <div id="chase_mode_popover_container">
        <Popover
            isOpen={isPopoverOpen}
            positions={['left']}
            padding={10}
            onClickOutside={() => setIsPopoverOpen(false)}
            content={ <SettingsForm />}
        >
            <img
                src={SettingsIcon}
                alt="Settings"
                height="16"
                width="16"
                onClick={() => setIsPopoverOpen(!isPopoverOpen)}
            />
        </Popover>
    </div>
}

export default SettingsPopover