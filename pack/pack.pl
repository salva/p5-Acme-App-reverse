#!/usr/bin/perl

use strict;
use warnings;

use Win32::Packer;
use Path::Tiny;
use Log::Any::Adapter;

Log::Any::Adapter->set('Stderr', log_level => 'trace');

my $guid = '5890c802-e94c-47a7-8238-bdbbeb68a05d';

my $packer = Win32::Packer->new( app_name => 'Reverse!',
                                 app_version => '0.1',
                                 app_vendor => 'Barcelona Perl & Friends 2017',
                                 app_id => $guid,
                                 app_subsystem => 'windows',

                                 license => path('LICENSE.RTF')->absolute,
                                 icon => path('reverse.ico')->absolute,

                                 scripts => { path => path('reverse.pl')->absolute,
                                              # subsystem => 'windows',
                                              shortcut => 'Reverse!',
                                              shortcut_description => 'The super-incredible string reverser!' },

                                 extra_dir => path('xrc')->absolute,
                                 extra_file => [ path('reverse.ico')->absolute,
                                                 path('LICENSE.RTF')->absolute ],

                                 extra_inc => path('lib')->absolute,
                                 extra_module => [qw(if)],

                                 output_dir => path('..')->absolute,
                               );

$packer->make_installer(type => 'msi');
