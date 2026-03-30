--// DEPENDENCIES
local Signal = require("@self/Objects/Signal")


--// MODULE DECLARATION
local Framework = {}


--// CLASS DECLARATIONS
Framework.Signal = Signal


--// TYPE EXPORTS
export type SignalConnection = Signal.SignalConnection
export type Signal<T...> = Signal.Signal<T...>


--// MODULE END
return Framework