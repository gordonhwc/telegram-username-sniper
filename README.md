# telegram-username-sniper

This is a maintained fork of the
archived [qg5/telegram-username-sniper](https://github.com/qg5/telegram-username-sniper), with containerized startup via
`Dockerfile` and `compose.yaml`.

## What it does

The app checks username availability through [Fragment](https://fragment.com/) and then tries to claim the username
through the [Telegram API](https://core.telegram.org/api). Depending on your config, it can claim the username for your
account or create a channel and assign the username there.

## Features

- Claim usernames to either `user` or `channel`
- Monitor multiple usernames
- Interactive Telegram login
- Persistent Telegram session stored in `data/session_DO_NOT_SHARE.json`
- Docker Compose workflow
- Plain Docker build and run workflow

## Requirements

- Docker
- A Telegram account
- Telegram `api_id` and `api_hash` from [Telegram's API setup guide](https://core.telegram.org/api/obtaining_api_id)

## Runtime Files

Everything the container needs at runtime lives under `data/`:

- `data/config.json`: app configuration
- `data/session_DO_NOT_SHARE.json`: Telegram session file created after first login

The container only needs this one directory mounted.

## Configuration

Edit `data/config.json`:

```json
{
  "telegram": {
    "phone_number": "",
    "api_id": 0,
    "api_hash": ""
  },

  "claim_to": "channel",
  "sleep_between_check": 100,
  "usernames": [
    "waquan"
  ]
}
```

Field reference:

- `telegram.phone_number`: your Telegram phone number in international format, for example `+12342348237`
- `telegram.api_id` and `telegram.api_hash`: Telegram API credentials
- `claim_to`: either `channel` or `user`
- `sleep_between_check`: delay between checks in milliseconds; values under `100` may trigger rate limits
- `usernames`: list of usernames to monitor

## Usage

### Docker Compose

```bash
git clone https://github.com/gordonhwc/telegram-username-sniper
cd telegram-username-sniper
docker compose up --build
```

Notes:

- Edit `data/config.json` before the first run
- Keep the terminal attached on the first run because Telegram login is interactive
- The session file will be created automatically at `data/session_DO_NOT_SHARE.json`

### Docker Only

```bash
git clone https://github.com/gordonhwc/telegram-username-sniper
cd telegram-username-sniper
docker build --tag telegram-username-sniper .
docker run --rm -it --volume "$(pwd)/data:/data" telegram-username-sniper
```

## FAQ

**Q: Can I snipe usernames that are currently on auction at Fragment?**

**A:** No. Auction usernames are auto-swapped, so they do not become available for normal claiming.

**Q: Can I use a bot token?**

**A:** No. Bots do not have access to `channels.createChannel` and `account.updateUsername`, which are required here.

**Q: Why claim to a channel instead of a user?**

**A:** `channel` is usually the safer choice because it tends to hit fewer rate limits. You can still auction channel
usernames on [Fragment](https://fragment.com/).

**Q: Can I monitor a lot of usernames at once?**

**A:** You can, but it is not recommended. Monitoring fewer usernames generally improves your chance of reacting quickly
when one becomes available.

**Q: How can I look for usernames worth targeting?**

**A:** Two common approaches are:

- watch marketplaces where Telegram usernames are being sold
- check inactive Telegram accounts that may eventually be deleted due to inactivity
