#!/usr/bin/ruby
#created Dec 6, 2024
# added more comments on June 16, 2026

suitCont = "23456789TJQKA" # T = 10; J=Jack;Q = Queen; K = King; A = ACE
suits = ["spade", "heart", "club", "daimond"]

class Player
	def initialize(n)
		@hand = []
		@chips = []
		@name = n
	end
	
	def showHand()
		for h in @hand
			puts h.getFace + " " + h.getSuit
		end
	end

	def getHand()
		@hand
	end
	
	def addToHand(item)
		@hand << item
	end
	
	def getChips()
		@chips
	end

	def sortHand() # the to_i is a hack i learned from stackoverflow. Otherwise IDK why we get the ARgumentError
		@hand = @hand.sort { |l,r| getCardInt(l.getFace()).to_i <=> getCardInt(r.getFace()).to_i}
	end
	
	def getName()
		@name
	end
	
	def clearHand()
		@hand = []
	end
end

class Card
	def initialize(f,s)
		@face,@suit = f,s
	end
	
	def getFace()
	@face
	end
	
	def getSuit()
	@suit
	end
end


def getCardInt(faceStr)
	if faceStr == nil
		puts "has a nil"
		return 0
	end
	case 
	when faceStr == "T" then 10 
	when faceStr == "A" then 14
	when faceStr == "J" then 11	
	when faceStr == "Q" then 12
	when faceStr == "K" then 13
	else 
		faceStr.to_i
	end
end


#finds left-most pair if one exists
def hasPair(hand) # must be pre-sorted
	i = 0
	
	while i < hand.length
		if i+1 < hand.length
			if hand[i].getFace() == hand[i+1].getFace()
				return i
			end
		end
		i += 1
	end

	return -1
end


def hasTwoPair(hand)
	p = hasPair(hand)
	p2 =-1
	
	if p != -1
		p2 = hasPair(hand[(p+1)..hand.length])
	end
	val = 0
	if p != -1 && p2 != -1
		val = getCardInt(hand[p].getFace()).to_i + getCardInt(hand[p+1+p2].getFace()).to_i
	else
		val = 0
	end
	
	return val
end


def hasThreeOfAKind(hand)
	i = 0
	
	while i < hand.length
		if i+2 < hand.length
			if hand[i].getFace() == hand[i+1].getFace() && hand[i+1].getFace() == hand[i+2].getFace()
				return i
			end
		end
		i += 1
	end

	return -1
end


def hasStraight(hand)
	i = 0
	
	# ace counts as 1 if we look for a straight
	if hand[0].getFace() == "A" && hand[1].getFace() == "2" && hand[2].getFace() == "3" && hand[3].getFace() == "4" && hand[4] == "5"
		return getCardInt(hand[hand.length-1].getFace())
	end
	
	while i < hand.length
		if i + 1 < hand.length
			if ! (((getCardInt(hand[i+1].getFace())) - ( getCardInt( hand[i].getFace() ))) == 1)
				 return -1
			end
		end
		i+= 1
	end
	
	return getCardInt(hand[hand.length-1].getFace())
end


def hasFlush(hand)
	
	i = 0
	while i < hand.length - 1
		if hand[i].getSuit() != hand[i+1].getSuit()
			return -1
		end
		i +=  1
	end
	
	return 1
end


def hasFullHouse(hand)
	
	got = hasThreeOfAKind(hand)

	if got == -1
		return -1
	end
	
	remaining = []
	if got == 0
		remaining = hand[3..(hand.length-1)]
	elsif got == 2
		remaining = hand[0..1]
	end
	
	
	got2 = hasPair(remaining)
	
	if got2 == -1
		return -1
	end
	
	
	return getCardInt( hand[got].getFace() )
end


def hasFourOfAKind(hand)
	if !( hand[0].getFace() == hand[1].getFace() && hand[1].getFace() == hand[2].getFace && hand[2].getFace() == hand[3].getFace()) && !( hand[1].getFace() == hand[2].getFace() && hand[2].getFace() == hand[3].getFace && hand[3].getFace() == hand[4].getFace())
		return -1
	end
	
	return getCardInt(hand[3].getFace()) # just one that is in the set
	
end


def hasStraightFlush(hand) # accounts for royal flushes aswell. They simply win with this routine.
	if hasStraight(hand) != -1 && hasFlush(hand) != -1
		return getCardInt(hand[hand.length-1].getFace())
	end
	
	return -1
end


def evalHand(hand)
	case
	when hasStraightFlush(hand) != -1 then 99999999 + hasStraightFlush(hand)
	when hasFourOfAKind(hand) != -1 then 9999999 + hasFourOfAKind(hand)
	when hasFullHouse(hand) != -1 then 999999 + hasFullHouse(hand)
	when hasFlush(hand) != -1 then 99999
	when hasStraight(hand) != -1 then
		hs = hasStraight(hand)
		9999 + hs
	when hasThreeOfAKind(hand) != -1 then 
		th = hasThreeOfAKind(hand)
		got = getCardInt(hand[th].getFace())
		boundry = 999
		boundry + got
	when hasTwoPair(hand) != 0 then hasTwoPair(hand) + 99
	when hasPair(hand) != -1 then
		p = hasPair(hand)
		getCardInt(hand[p].getFace())
	else
	-2
	end
end

#######################

#note: type them out sortedly
#these are tests pls ignor

#h = [Card.new("9","a"), Card.new("9","a"), Card.new("9","a"), Card.new("Q","a"),Card.new("7","a")]
#g = [Card.new("9","b"), Card.new("9","a"), Card.new("9","a"), Card.new("Q","a"),Card.new("7","a")]

#fullh = [Card.new("9","b"), Card.new("9","a"), Card.new("9","a"), Card.new("7","a"),Card.new("7","a")]
#fullh2 = [Card.new("2","b"), Card.new("2","a"), Card.new("7","a"), Card.new("7","a"),Card.new("7","a")]
#foak = [Card.new("2","b"), Card.new("3","a"), Card.new("3","a"), Card.new("3","a"),Card.new("3","a")]
stfl = [Card.new("4","a"), Card.new("5","a"), Card.new("6","a"), Card.new("7","a"),Card.new("8","a")]
nastfl = [Card.new("A","a"), Card.new("5","a"), Card.new("6","a"), Card.new("7","a"),Card.new("8","a")]
#if hasStraight(h) != -1
#	puts "has straight"
#end
#if hasFlush(h) != -1
#	puts("h has flush")
#end

#if hasFlush(g) != -1
#	puts("g has flush")
#end

#if hasFullHouse(fullh) != -1
#	puts("has full house")
#end

#if hasFullHouse(g) != -1
#	puts("has full house 2")
#end

#if hasFullHouse(fullh2) != -1
#	puts("has full house 3")
#end

#if hasFourOfAKind(foak) != -1
#	puts "has four of a kind"
#else #
#	puts "nope"
#end

#if hasStraightFlush(stfl) != -1
#	puts "test says straight flush"
#end

#if hasStraightFlush(nastfl) != -1
#	puts "test says straight flush 2"
#end

##########################



orderedDeck = []
wallet = 1000
jackp = 0
#create deck
for s in suits
	for f in suitCont.split(//)
		orderedDeck << Card.new(f,s)
	end
end

players = [Player.new("Silvia bigtime smoker"), Player.new("You")] # it's array index is it's id number

if ARGV[0] == "3" || ARGV[0] == "4"
	players << Player.new("Dagon")
end

if ARGV[0] == "4"
	players << Player.new("Scarlet")
end

# main game loop
origDeck = orderedDeck
matchs = 0
while 1	
	if wallet <= 0
		puts "You lost all your money"
		sleep(20)
		break;
	end
	
	puts "##############"
	puts "round: " + matchs.to_s
	
	
	deck = []
	#shuffle
	orderedDeck = origDeck
	for i in 0..(orderedDeck.length)
		r = rand(orderedDeck.length)
		deck << orderedDeck[r]
		#delete the selected card
		orderedDeckTmp = orderedDeck[0..(r-1)]
		for c in orderedDeck[(r+1)..(orderedDeck.length)]
			orderedDeckTmp << c
		end
		orderedDeck = orderedDeckTmp
	end

	hands = []
	

	#deal cards
	handLim = 5
	itr = handLim * players.length
	hands = deck[(deck.length - itr)..(deck.length-1)]

	for p in players
		p.clearHand()
	end

	i = 0
	while hands != nil && i < hands.length
		players[i % players.length].addToHand(hands[i])
		i += 1
	end




	winning = players
	#sort all hands for convience of players and easier hand evaluation
	for p in players
		p.sortHand()
		
		#if hasPair(p.getHand()) != -1
		#	puts("has a pair")
		#end

		#if hasTwoPair(p.getHand())
		#	puts "has two-pair"
		#end

	end
	
	#show our hand and score
	for w in players
		if w.getName() == "You" #computer science rocks
			puts "_ player _"
			puts w.getName()
			puts "_ score _"
			puts evalHand w.getHand()
			puts ""
			w.showHand()
		end
	end
	
	puts "you have " + wallet.to_s
	puts "bet: "

	betStr = $stdin.readline()
	bet = betStr.to_i
	wallet -= bet
	jackp = players.length * bet

	# find winner
	winning = winning.sort {|l,r| evalHand(l.getHand()).to_i <=> evalHand(r.getHand()).to_i}

	if evalHand(winning[winning.length-1].getHand()) == evalHand(winning[winning.length-2].getHand())
		puts "## tie ##"
	else 
		puts "## winner is " + winning[winning.length-1].getName() + "##"

		if winning[winning.length-1].getName() == "You"
			wallet += jackp
		end
	end
	sleep(2.4)

	jackp = 0
	
	for w in winning
		if w.getName() != "You"
			puts "_ player _"
			puts w.getName()
			puts "_ score _"
			puts evalHand w.getHand()
			puts ""
			w.showHand()
		end
	end
	
	matchs += 1
end
