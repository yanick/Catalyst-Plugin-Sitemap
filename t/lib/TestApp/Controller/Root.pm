package TestApp::Controller::Root;

use strict;
use warnings;

use parent 'Catalyst::Controller';

sub sitemap : Path('/sitemap') {
    my ( $self, $c ) = @_;

    $c->res->body( $c->sitemap );
}

sub alone :Path('/alone') :Sitemap { }

sub with_priority :Path('/with_priority') :Sitemap(0.75) { }

sub with_function :Path('/with_function') :Sitemap(*) { }

sub with_function_sitemap {
    $_[2]->add( 'http://localhost/with_function' );
}

sub with_args :Path('/with_args') 
    :Sitemap( lastmod => 2010-09-27, changefreq => daily ) 
    {}


1;






