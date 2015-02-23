package Catalyst::Plugin::Sitemap;
# ABSTRACT: Sitemap support for Catalyst.

use strict;
use warnings;

use Moose::Role;

no warnings qw/uninitialized/;

use WWW::Sitemap::XML;
use List::Util qw/ first /;

has sitemap => (
    is      => 'ro',
    builder => '_build_sitemap',
    lazy    => 1,
);

sub sitemap_as_xml {
    return $_[0]->sitemap->as_xml->toString;
}

sub _build_sitemap {
    my $self = shift;

    my $sitemap = WWW::Sitemap::XML->new;

    for my $controller ( map { $self->controller($_) } $self->controllers ) {
        for my $action ( $controller->get_action_methods ) {
            $self->_add_controller_action_to_sitemap( $sitemap, $controller, $action );
        }
    }

    return $sitemap;
}

sub _add_controller_action_to_sitemap {
    my( $self, $sitemap, $controller, $act ) = @_;

    my $action = $controller->action_for($act->name);

    my $attr = $action->attributes->{Sitemap} or return;

    die "more than one attribute 'Sitemap' for sub ", $act->fully_qualified_name
        if @$attr > 1;

    my @attr = split /\s*(?:,|=>)\s*/, $attr->[0];

    my %uri_params;

    if ( @attr == 1 ) {
        if ( $attr[0] eq '*' ) {
            my $sitemap_method = $action->name . "_sitemap";

            return $controller->$sitemap_method( $self, $sitemap )
                if  $controller->can($sitemap_method);
        }
        elsif ( $attr[0] + 0 > 0 ) { # it's a number
            $uri_params{priority} = $attr[0];
        }
    }
    elsif ( @attr > 0 ) {
        %uri_params = @attr;
    }

    $uri_params{loc} = $self->uri_for_action( $action->private_path );

    $sitemap->add(%uri_params);
}

1;
