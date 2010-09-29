package TestApp::Controller::Root;

use strict;
use warnings;

use parent 'Catalyst::Controller';

sub sitemap : Path('/sitemap') {
    my ( $self, $c ) = @_;

    $c->res->body( $c->sitemap->xml );
}

sub alone :Local :Sitemap { }

sub with_priority :Local :Sitemap(0.75) { }

sub with_function :Local :Sitemap(*) { }

sub with_function_sitemap {
    $_[2]->add( 'http://localhost/root/with_function' );
}

sub with_args :Local 
    :Sitemap( lastmod => 2010-09-27, changefreq => daily ) 
    {}


1;






