#!/usr/bin/perl

use strict;
use warnings;
#use LWP::Simple;
#use HTTP::Status qw(:constants :is status_message);
use LWP::UserAgent;
use HTML::TokeParser;


my $url = 'http://www.homedepot.com/webapp/wcs/stores/servlet/ContentView?pn=Outdoors_Container&langId=-1&storeId=10051&catalogId=10053';
#my $url = 'http://homedepot.com';
#my $url = 'http://yahoo.com';
#my $url = 'http://elliotholden.com';

my $ua = LWP::UserAgent->new();

#print "\n";

#my $get = $ua->get($url);
#foreach my $key (keys(%$get)) {
#   print "$key:" . $get->{$key} . "\n";
#}

print "\n";

my $head = $ua->head($url);
foreach my $key (keys(%$head)) {
   print "$key:" . $head->{$key} . "\n";
}

print "\n";

print $head->status_line . "\n";

print "\n";

foreach ($head->{_headers}->header_field_names) {
   print $_ . ":" . $head->{_headers}->header($_) . "\n";
} 

exit;
