#!/usr/bin/perl -w
use Net::Twitter;
use Scalar::Util 'blessed';
use Data::Dumper;
use strict;
 
my $nt = Net::Twitter->new(
      traits                 => [qw/API::RESTv1_1/],
      consumer_key           => "<<your key>>",
      consumer_secret        => "<<your secret>>",
      access_token           => "<<your token>>",
      access_token_secret    => "<<your token secret>>",
      ssl                    => '1',
      decode_html_entities   => '1',
);

while(){
print "ok, starting new search loop...\n";
my $result = $nt->search("%40sternibirke");

open FILE, "tweetids.txt" or die $!;
my @lines = <FILE>;
close FILE;

my $identity;

foreach my $status (@{$result->{'statuses'}}) {
    $identity = $status->{id};              # Tweet ID
    #print $status->{user}->{screen_name};   # Screen Name
    my $s = $status->{text};                # Tweeted Text
    $s =~ s/[^[:ascii:]]+//g;               # Strip Non-ASCII Encoded Characters
    print $identity;             # Tweet ID | Tweeted Text

  #check if id already exists

  if ($identity ~~ @lines)
	{
  print "yes, got it on file\n";
        }
  else
        {
  open FILE2, "+>>tweetids.txt" or die $!;
  print "new id is recorded to file";
  #write new id to file
  print FILE2 $identity."\n";
  close FILE2;
  #action do the blinky-winky
  print "I AM BLINKING NOW\n";
  system("/opt/fhem/fhem.pl 7072 'set Mobsteck2 off'");
  system("/opt/fhem/fhem.pl 7072 'set Mobsteck2 on'");
        }
};
sleep(60);
}
