snapshots = {
    {name = "base",  modules = {"alpine"}},
    {name = "setup", modules = {"network", "patch"}},
}

path = {
    run = "/home/bkubisiak/src/eib/eib-run.sh",
    mod = "/home/bkubisiak/src/eib/mod",
}

alpine = {
    ARCH = "aarch64",
    KEYS = "/home/bkubisiak/src/aports/main/alpine-keys",
    MIRROR = "http://10.10.0.4/alpine",
    VERSION = "v3.12",
    PACKAGES = "alpine-base dropbear erlang wireguard-tools",
    -- RMPACKAGES = "",
    SERVICES = "dropbear",
}

network = {
    DEVNAME = "finch",
}

patch = {
    DIRECTORIES = "overlay/",
}
