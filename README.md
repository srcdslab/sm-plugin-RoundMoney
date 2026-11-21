# RoundMoney

SourceMod plugin for Counter-Strike: Source that gives every player a fixed amount of money at each
round start, for "16k" servers.

`mp_startmoney` is not enough for that: the game only applies it when a player first joins and on
`mp_restartgame`. Afterwards money carries over from round to round.

## How it works

On `player_spawn`, one frame later, the player's money (`m_iAccount` netprop) is set to
`sm_roundmoney_amount`. Every player spawns at round start and a late joiner gets the money on his
first spawn. Nothing runs during the round, so buying and kill rewards are never touched.

No gamedata, offsets or SDK calls: works on CS:S x86 and x64.

## Installation

Extract the release archive matching your SourceMod version (`-sm1.12` or `-sm1.13`) into `cstrike/`:

- `addons/sourcemod/plugins/RoundMoney.smx`

The config `cfg/sourcemod/plugin.RoundMoney.cfg` is created on first load.

## Cvars

| Cvar | Default | Description |
| - | - | - |
| `sm_roundmoney_enable` | `1` | Give every player a fixed amount of money when they spawn |
| `sm_roundmoney_amount` | `16000` | Amount of money given, `0` to `16000` (the CS:S cap) |

Recommended with it: `mp_startmoney 16000`, so a player who joins mid-round already sees 16000 in the
buy menu.

## License

GPL-3.0, see [LICENSE](LICENSE).
