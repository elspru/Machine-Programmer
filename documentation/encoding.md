-   [Pyash Encoding](#pyash-encoding)
    -   [VLIW’s Head Index](#vliws-head-index)
    -   [Word Compression](#word-compression)
        -   [CCVTC or CSVTF](#ccvtc-or-csvtf)
        -   [HCVTF](#hcvtf)
        -   [CSVT](#csvt)
        -   [CVT](#cvt)
    -   [Quotes](#quotes)
    -   [Extension](#extension)
    -   [Table of Values](#values)
        -   [definitions](#definitions)
    -   [Quoted Sort](#quoted-sort)

Pyash Encoding
==============

The virtual machine uses variable-length-instruction-word (VLIW), loosely inspired by [head and tails instruction format](http://scale.eecs.berkeley.edu/papers/hat-cases2001.pdf)(HTF). HTF uses VLIW’s which are 128 or 256 bits long, however there can be multiple instructions per major instruction word.

VLIW’s Head Index
-----------------

The head is really a parse index, to show the phrase boundaries. In TroshLyash each bit represents a word, each of which is 16bits, when a phrase boundary is met then the bits flip from 1 to 0 or vice-versa at the phrase boundary word. index takes up the first 16bits of the VLIW. This would lead to 256bit (32Byte) VLIW’s. The real advantage of the indexing occurs when there either multiple sentences per VLIW, or when there are complex sentences in the VLIW’s. Having the VLIW’s broken up into 32Byte chunks, makes it easier to address function entry points, which can be placed at the beginning of a VLIW. Can fit 16 VLIWS in a POSIX page, 128 VLIW’s in a Linux page, so would only need 1 byte (8bits) for addressing functions that are within 1 page distance.

Word Compression
----------------

Now for the slightly more interesting issue of packing as many as 5 glyphs into a mere 16 bits. Why this is particularly interesting is that there is an alphabet of 32 glyphs, which would typically required 5 bits each, and thus 25bits in total. However the 16 bit compression is mostly possible due to the rather strict phonotactics of TroshLyash, as only certain classes of letters can occur in any exact place. The encoding supports 4 kinds of words, 2 grammar word classes and 2 root word classes. Where C is a consonant, T is a tone and V is a vowel, they are CVT, CCVT, and CVTC, CCVTC respectively.

### CCVTC or CSVTF

I’ll start with explaining the simplest case of the CCVTC word pattern. To make it easier to understand the word classes can call is the CSVTF pattern, where S stands for Second consonant, and F stands for Final Consonant. The first C represents 22 consonants, so there needs to be at least 5 bits to represent them. Here are the various classes “C”:<span>\[</span>“p”,“t”,“k”,“f”, “s”,“c”,“x”, “b”,“d”,“g”,“v”, “z”,“j”, “n”,“m”,“q”,“r”, “l”,“y”,“w”<span>\]</span>, “S”:<span>\[</span>“f”,“s”,“c”,“y”, “r”,“w”,“l”,“x”, “z”,“j”,“v”<span>\]</span>, “V”:<span>\[</span>“i”,“a”,“e”,“o”,“u”,“6”<span>\]</span>, “T”:<span>\[</span>“7”,“\_”<span>\]</span>, “F”:<span>\[</span>“p”,“t”,“k”,“f”, “s”,“c”,“n”,“m”<span>\]</span>, (can check the [phonology](http://wyn.bot.nu/spel/src/vocab/gen/phonology.html) page for pronunciation) C needs 5 bits, S would need 4 bits, however the phonotactics means that if the initial C is voiced, then the S must be voiced, thus “c” would turn into “j”, “s” into “z” and “f” into “v”, also none of the ambigiously voiced phonemes (l, m, n, q, y, w, r) can come before a fricative because they have a higher sonority, thus must be closer to the vowel. So S only needs 3 bits. V needs 3 bits T needs 2 bits and F needs 3 bits which is a total of 16 bits. 5+3+3+2+3 = 16 However there are other kinds of words also. we’ll see how those work.

### HCVTF

So here we have to realize that CVC or CVTC is actually HCVTF due to alignment. So what we do is make a three bit trigger from the first word, the trigger is 0, which can be three binary 0’s, 0b000 3+5+3+2+3 = 16 H+C+V+T+C this does mean that now 0b1000, 0b10000 and 0b11000 is no longer useable consonant representation, however since there are only 22 consonants, and only 2 of those are purely for syntax so aren’t necessary, so that’s okay, simply can skip the assignment of 8, 16 and 24.

### CSVT

This is similar to the above, except we use 0b111 as the trigger, meaning have to also skip assignment of 15, 23 and 31. 3+5+3+3+2 = 16 ?+C+S+V+T

### CVT

For this one can actually simply have a special number, such as 30, which indicates that the word represents a 2 letter word. 5+5+3+2+1 ?+C+V+T+P what is P? P can be a parity-bit for the phrase, or simply unassigned.

Quotes
------

Now with VM encodings, it is also necessary to make reference to binary numbers and things like that. The nice thing with this encoding is that we can represent several different things. Currently with the above words, we have 1 number undefined in the initial 5 bits. 29 can be an initial dot or the final one, can call the the quote-denote (QF), depending on if parser works forwards or backwards. Though for consistency it is best that it is kept as a suffix (final one), as most other things are suffixes. 5+3+8 = 16 Q+L+B QF has a 3 bit argument of Length. The Length is the number of 16bit fields which are quoted, if the length is 0, then the B is used as a raw byte of binary. Otherwise the B represents the encoding of the quoted bytes, mostly so that it is easier to display when debugging. The type information is external to the quotes themselves, being expressed via the available TroshLyash words. So in theory it would be possible to have a number that is encoded in UTF-8, or a string that is encoded as a floating-point-number. Though if the VM interpreter is smart then it will make sure the encoding is compatible with the type Lyash type, and throw an error otherwise.

Extension
---------

This encoding already can represent over 17,000 words, which if they were all assigned would take 15bits, so it is a fairly efficient encoding. However the amount of words can be extended by increasing number of vowels, as well as tones. And it may even be possible to add an initial consonant if only one or two of the quote types is necessary. However this extension isn’t likely to be necessary anytime in the near future, because adult vocabulary goes up to around 17,000 words, which includes a large number of synonyms. For instance the Lyash core words were generated by combining several different word-lists, which were all meant to be orthogonal, yet it turns out about half were internationally synonyms, so were cut down from around eight thousand to around four thousand words. It will be possible to flesh out the vocabulary with compound words and more technical words later on. Also it might make sense to supplant or remove some words like proper-names of countries.

Table of Values
---------------

<span>@llllll@</span>

\[b\]<span>0.14</span>\#

&

\[b\]<span>0.14</span>C

&

\[b\]<span>0.14</span>S

&

\[b\]<span>0.14</span>V

&

\[b\]<span>0.14</span>T

&

\[b\]<span>0.14</span>F

\[t\]<span>0.14</span>width

&

\[t\]<span>0.14</span>5

&

\[t\]<span>0.14</span>3

&

\[t\]<span>0.14</span>3

&

\[t\]<span>0.14</span>2

&

\[t\]<span>0.14</span>3

\[t\]<span>0.14</span>0

&

\[t\]<span>0.14</span>SRF

&

\[t\]<span>0.14</span>y

&

\[t\]<span>0.14</span>i

&

\[t\]<span>0.14</span>MT

&

\[t\]<span>0.14</span>m

\[t\]<span>0.14</span>1

&

\[t\]<span>0.14</span>m

&

\[t\]<span>0.14</span>w

&

\[t\]<span>0.14</span>a

&

\[t\]<span>0.14</span>7

&

\[t\]<span>0.14</span>k

\[t\]<span>0.14</span>2

&

\[t\]<span>0.14</span>k

&

\[t\]<span>0.14</span>s z

&

\[t\]<span>0.14</span>u

&

\[t\]<span>0.14</span>\_

&

\[t\]<span>0.14</span>p

\[t\]<span>0.14</span>3

&

\[t\]<span>0.14</span>y

&

\[t\]<span>0.14</span>l

&

\[t\]<span>0.14</span>e

&

\[t\]<span>0.14</span>U

&

\[t\]<span>0.14</span>n

\[t\]<span>0.14</span>4

&

\[t\]<span>0.14</span>p

&

\[t\]<span>0.14</span>f v

&

\[t\]<span>0.14</span>o

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>s

\[t\]<span>0.14</span>5

&

\[t\]<span>0.14</span>w

&

\[t\]<span>0.14</span>c j

&

\[t\]<span>0.14</span>6

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>t

\[t\]<span>0.14</span>6

&

\[t\]<span>0.14</span>n

&

\[t\]<span>0.14</span>r

&

\[t\]<span>0.14</span>U

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>f

\[t\]<span>0.14</span>7

&

\[t\]<span>0.14</span>LGF

&

\[t\]<span>0.14</span>x

&

\[t\]<span>0.14</span>U

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>c

\[t\]<span>0.14</span>8

&

\[t\]<span>0.14</span>SRO

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

\[t\]<span>0.14</span>9

&

\[t\]<span>0.14</span>s

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

\[t\]<span>0.14</span>10

&

\[t\]<span>0.14</span>t

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

\[t\]<span>0.14</span>11

&

\[t\]<span>0.14</span>l

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

\[t\]<span>0.14</span>12

&

\[t\]<span>0.14</span>f

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

\[t\]<span>0.14</span>13

&

\[t\]<span>0.14</span>c

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

\[t\]<span>0.14</span>14

&

\[t\]<span>0.14</span>r

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

\[t\]<span>0.14</span>15

&

\[t\]<span>0.14</span>LGO

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

\[t\]<span>0.14</span>16

&

\[t\]<span>0.14</span>SRO

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

\[t\]<span>0.14</span>17

&

\[t\]<span>0.14</span>b

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

\[t\]<span>0.14</span>18

&

\[t\]<span>0.14</span>g

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

\[t\]<span>0.14</span>19

&

\[t\]<span>0.14</span>d

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

\[t\]<span>0.14</span>20

&

\[t\]<span>0.14</span>z

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

\[t\]<span>0.14</span>21

&

\[t\]<span>0.14</span>j

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

\[t\]<span>0.14</span>22

&

\[t\]<span>0.14</span>v

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

\[t\]<span>0.14</span>23

&

\[t\]<span>0.14</span>LGO

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

\[t\]<span>0.14</span>24

&

\[t\]<span>0.14</span>SRO

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

\[t\]<span>0.14</span>25

&

\[t\]<span>0.14</span>q

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

\[t\]<span>0.14</span>26

&

\[t\]<span>0.14</span>x

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

\[t\]<span>0.14</span>27

&

\[t\]<span>0.14</span>1

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

\[t\]<span>0.14</span>28

&

\[t\]<span>0.14</span>8

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

\[t\]<span>0.14</span>29

&

\[t\]<span>0.14</span>QF

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

\[t\]<span>0.14</span>30

&

\[t\]<span>0.14</span>SGF

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

\[t\]<span>0.14</span>31

&

\[t\]<span>0.14</span>LGO

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

&

\[t\]<span>0.14</span>

### definitions

  
blank means out of bounds

U  
undefined

MT  
middle tone, no marking

QF  
quote denote

SGF  
short grammar word denote

SRF  
short root word denote

LGF  
long grammar word denote

SRO  
short root word denote overflow

LGO  
long grammar word denote overflow

Quoted Sort
-----------

\[endianness=little, bitwidth=0.0625\]<span>16</span>
& & & &

<span>\*<span>5</span><span>|l</span>|</span>
0 4 & 5 6 & 7 9 & 10 11 & 12 15
5 tidbit & 2 tidbit & 3 tidbit & 2 tidbit & 4 tidbit
quote denote & ingredient thick & vector thick & region & sort denote
0 & 1 byte, 8 tidbit & 1 & literal & glyph
1 & 2 byte, 16 tidbit & 2 & global & word
2 & 4 byte, 32 tidbit & 4 & constant & phrase
3 & 8 byte, 64 tidbit & 8 & local & sentence
4 & & 16 & & text
5 & & U & & function
6 & & U & & database
7 & & 3 & & named database
8 & & & & unsigned integer
9 & & & & signed integer
A & & & & floating point number
B & & & & U
C & & & & U
D & & & & U
E & & & & U
F & & & & U

The quote denote is 5 bits long, leaving 11 bits. the next 2 bits is used to indicate bit width of quote ingredient(s), the following 3 bits is used to indicate the number of vector ingredient(s), 2 bit for region

1.  literal

2.  global memory referential

3.  constant memory referential

4.  local memory referential

4 bits for noun denote:

1.  glyph

2.  word

3.  phrase

4.  sentence

5.  text

6.  function

7.  datastructure

8.  named data type, next 16 bits gives name

9.  unsigned integer

10. signed integer

11. floating point number
