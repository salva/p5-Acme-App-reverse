package Acme::App::reverse;

our $VERSION = '0.01';

use 5.024;

use strict;
use warnings;
use feature qw(signatures);
no warnings qw(experimental::signatures);

use Wx qw(wxBITMAP_TYPE_ICO);
use Wx::Event qw(:everything);
use Wx::XRC;
use Path::Tiny;

sub new {
    my $class = shift;
    my $app = Wx::SimpleApp->new;
    my $xrc = Wx::XmlResource->new();
    $xrc->InitAllHandlers;
    my $xrc_fn = path($0)->absolute->parent->child('xrc', 'reverse.xrc');
    $xrc->Load("$xrc_fn");
    my $frame = $xrc->LoadFrame(undef, 'main_frame');

    if ($^O eq 'MSWin32') {
        my $icon = Wx::Icon->new(path($0)->absolute->parent->child('reverse.ico')->canonpath,
                                 wxBITMAP_TYPE_ICO);
        $frame->SetIcon($icon);
    }

    my $ctrl1_id = Wx::XmlResource::GetXRCID('text_ctrl_1');
    my $ctrl2_id = Wx::XmlResource::GetXRCID('text_ctrl_2');
    my $ctrl1 = $frame->FindWindow($ctrl1_id);
    my $ctrl2 = $frame->FindWindow($ctrl2_id);

    my $last_v = $ctrl1->GetValue;

    my $self = { app => $app,
                 xrc => $xrc,
                 frame => $frame,
                 ctrl1_id => $ctrl1_id,
                 ctrl2_id => $ctrl2_id,
                 ctrl1 => $ctrl1,
                 ctrl2 => $ctrl2,
                 last_v => \$last_v };

    EVT_TEXT($frame, $ctrl1_id, sub {
                 my $v = $ctrl1->GetValue;
                 if ($v ne $last_v) {
                     $last_v = $v;
                     my $rv = reverse $v;
                     warn "$v => $rv\n";
                     $ctrl2->SetValue($rv)
                 }
             });

    EVT_TEXT($frame, $ctrl2_id, sub {
                 my $rv = $ctrl2->GetValue;
                 my $v = reverse $rv;
                 if ($v ne $last_v) {
                     $last_v = $v;
                     warn "$rv => $v\n";
                     $ctrl1->SetValue($v)
                 }
             });

    bless $self, $class;
}

sub run ($self) {
    $self->{frame}->Show;
    $self->{app}->MainLoop;
}

1;
__END__

=head1 NAME

Acme::App::reverse - Perl graphical application for reversing strings

=head1 SYNOPSIS

  my $app = Acme::App::Reverse->new;
  $app->run;

=head1 DESCRIPTION

This incredible application provides an user friendly interface for
reversing strings as you type.

=head2 SEE ALSO

This application was used as part of the presentation given on the
Barcelona Perl & Friends conference (aka Barcelona Perl Workshop 2017).

=head1 AUTHOR

Salvador Fandiño, E<lt>sfandino@yahoo.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2017 by Salvador Fandiño

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.26.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
