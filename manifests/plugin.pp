# Define: elasticsearch::plugin
#
# Installs elasticsearch plugin
#
# Actions:
#  - Install specific elasticsearch plugins
#
# Parameters:
# - [$title]      - Title of plugin
# - [$ensure]     - Should plugin be installed. Default is to remove.
# - [$plugin_dir] - The name of the plugin directory to be installed
#
# Requires:
# - The elasticsearch module
#
# Example:
#
#  elasticsearch::plugin { 'foo-plugin':
#    ensure     => 'present',
#    plugin_dir => 'foo',
#  }
#
define elasticsearch::plugin(
  $ensure     = 'present',
  $plugin_dir = undef
  ) {

  if !$plugin_dir {
    fail("plugin_dir undefined: specify plugin destination dir for ${title}")
  }

  case $ensure {
    'installed', 'present': {
      exec {"install-plugin-${title}":
        command => "${elasticsearch::params::bin_plugin} -install ${title}",
        creates => "${elasticsearch::params::dir_plugins}/${plugin_dir}",
        require => Package['elasticsearch'],
        notify  => Service['elasticsearch'];
      }
    }
    default: {
      exec {"remove-plugin-${title}":
        command => "${elasticsearch::params::bin_plugin} -remove ${plugin_dir}",
        require => Package['elasticsearch'];
      }
    }
  }
}
