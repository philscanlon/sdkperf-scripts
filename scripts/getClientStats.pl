#!/usr/bin/perl -w

use Time::HiRes qw(time sleep);
use XML::Simple;
use Data::Dumper;

my $hostId = $ARGV[0];
my $iterations = $ARGV[1];
my $interval = $ARGV[2];

if (!@ARGV) {
  print "Usage:  getInterfaceStats.pl <VRS MGT IP Address> <Count> <Interval (seconds)>\n";
  exit();
}

my $start=time;
my $begin=time;
my $end=time;
my $processTime=time;


for ( $loop = 0; $loop < $iterations; $loop++ ) {

        $begin=time;
	$rpccallShow = "<rpc semp-version=\\\"soltr/6_2\\\"><show><stats><client></client></stats></show></rpc>";
	$SEMPrpc = `curl -s -u admin:solaceDemo -d \" $rpccallShow \" http://$hostId:80/SEMP`;
	$XMLResponse1 = XMLin($SEMPrpc);

	#print Dumper($XMLResponse1);

	$rpccallShow2 = "<rpc semp-version=\\\"soltr/6_2\\\"><show><message-spool></message-spool></show></rpc>";
	$SEMPrpc2 = `curl -s -u admin:solaceDemo -d \" $rpccallShow2 \" http://$hostId:80/SEMP`;
	$XMLResponse2 = XMLin($SEMPrpc2);

	#print Dumper($XMLResponse2);

	if (($XMLResponse1->{"execute-result"}->{"code"}) ne "ok"){
	  printf STDERR "error getting interface stats. Response = %s\n", $XMLResponse1;
	} elsif (($XMLResponse2->{"execute-result"}->{"code"}) ne "ok"){
	  printf STDERR "error getting interface stats. Response = %s\n", $XMLResponse2;
	} else {
	    printf "%d,%d,%d,%d,%d,%d,%s,%d,%d,%d,%f,%f,%f\n",
                  time-$start,
		  $XMLResponse1->{'rpc'}->{'show'}->{'stats'}->{'client'}->{'global'}->{'stats'}->{'total-clients-connected'},
		  $XMLResponse1->{'rpc'}->{'show'}->{'stats'}->{'client'}->{'global'}->{'stats'}->{'current-ingress-rate-per-second'},
		  $XMLResponse1->{'rpc'}->{'show'}->{'stats'}->{'client'}->{'global'}->{'stats'}->{'average-ingress-rate-per-minute'},
		  $XMLResponse1->{'rpc'}->{'show'}->{'stats'}->{'client'}->{'global'}->{'stats'}->{'current-egress-rate-per-second'},
		  $XMLResponse1->{'rpc'}->{'show'}->{'stats'}->{'client'}->{'global'}->{'stats'}->{'average-egress-rate-per-minute'},
		  $XMLResponse2->{'rpc'}->{'show'}->{'message-spool'}->{'message-spool-info'}->{'operational-status'},
		  $XMLResponse2->{'rpc'}->{'show'}->{'message-spool'}->{'message-spool-info'}->{'rfad-messages-currently-spooled'},
		  $XMLResponse2->{'rpc'}->{'show'}->{'message-spool'}->{'message-spool-info'}->{'disk-messages-currently-spooled'},
		  $XMLResponse2->{'rpc'}->{'show'}->{'message-spool'}->{'message-spool-info'}->{'total-messages-currently-spooled'},
                  $XMLResponse2->{'rpc'}->{'show'}->{'message-spool'}->{'message-spool-info'}->{'current-rfad-usage'},
                  $XMLResponse2->{'rpc'}->{'show'}->{'message-spool'}->{'message-spool-info'}->{'current-disk-usage'},
                  $XMLResponse2->{'rpc'}->{'show'}->{'message-spool'}->{'message-spool-info'}->{'current-persist-usage'};
	}
        $end=time;
        $processTime=$end-$begin;
            
	sleep($interval-$processTime);
}

exit();
