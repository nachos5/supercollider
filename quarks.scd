// 'Quarks'
Quarks.gui;
Quarks.openFolder;

Quarks.install("https://codeberg.org/madskjeldgaard/komet");

KometDependencies.check()
KometDependencies.installFaustPlugins()
KometDependencies.installPlugins()

Quarks.install("https://codeberg.org/madskjeldgaard/mk-synthlib")
M.installFaustPlugins();

Quarks.install("TimeStretch")
