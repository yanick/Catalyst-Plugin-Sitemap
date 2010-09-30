
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  'build_requires' => {
    'Carp' => '0',
    'Catalyst' => '0',
    'Catalyst::Controller' => '0',
    'Catalyst::Test' => '0',
    'Module::Build' => '0.3601',
    'Scalar::Util' => '0',
    'Test::More' => '0.94',
    'parent' => '0',
    'perl' => '5.004'
  },
  'configure_requires' => {
    'Module::Build' => '0.3601'
  },
  'dist_abstract' => 'Sitemap support for Catalyst.',
  'dist_author' => [
    'Yanick Champoux <yanick@babyl.dyndns.org>'
  ],
  'dist_name' => 'Catalyst-Plugin-Sitemap',
  'dist_version' => '0.0.1',
  'license' => 'perl',
  'module_name' => 'Catalyst::Plugin::Sitemap',
  'recommends' => {},
  'recursive_test_files' => 1,
  'requires' => {
    'List::Util' => '0',
    'Moose::Role' => '0',
    'Search::Sitemap' => '0'
  },
  'script_files' => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
