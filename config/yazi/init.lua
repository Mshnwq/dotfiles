require("relative-motions"):setup({ show_numbers="none", show_motion = true })

require("yamb"):setup {
  jump_notify = true,
  cli = "fzf",
  keys = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
  path = (os.getenv("HOME") .. "/.config/yazi/bookmark"),
}
