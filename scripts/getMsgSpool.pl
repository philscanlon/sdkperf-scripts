#!/usr/bin/perl -w

use XML::Simple;
use Data::Dumper;

my $hostId = $ARGV[0];

if (!@ARGV) {
  print "Usage:  getInterfaceStats.pl <VRS MGT IP Address> \n";
  exit();
}

my $rpccallShow = "<rpc semp-version=\\\"soltr/4_5\\\"><show><message-spool></message-spool></show></rpc>";
my $SEMPrpc = `curl -s -u mhobbis:mh101nrd -d \" $rpccallShow \" http://$hostId:80/SEMP`;
my $XMLResponse = XMLin($SEMPrpc);

#print Dumper($XMLResponse);

if (($XMLResponse->{"execute-result"}->{"code"}) ne "ok"){
  printf STDERR "error getting interface stats. Response = %s\n", $XMLResponse;
} else {
   #printf "      ClientTot  ClientData   ClientCtl    TotDisc    CompBytes     Rate(s)   Rate(min)\n";
    printf "%s,%d,%d,%d\n",
           $XMLResponse->{'rpc'}->{'show'}->{'message-spool'}->{'message-spool-info'}->{'operational-status'},
           $XMLResponse->{'rpc'}->{'show'}->{'message-spool'}->{'message-spool-info'}->{'rfad-messages-currently-spooled'},
           $XMLResponse->{'rpc'}->{'show'}->{'message-spool'}->{'message-spool-info'}->{'disk-messages-currently-spooled'},
           $XMLResponse->{'rpc'}->{'show'}->{'message-spool'}->{'message-spool-info'}->{'total-messages-currently-spooled'};
}

exit();

