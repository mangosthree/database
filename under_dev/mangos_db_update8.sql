-- Fixes for starting quests that involve training dummies

update creature_template set ainame = 'EventAI' where name = 'Training Dummy';

insert into creature_ai_scripts values (4454807,44389,8,0,100,0,20271,-1,0,0,33,44175,1,0,33,44420,1,0,0,0,0,0,'Training Dummy - On Judgement Spellhit (Quest 26918 Credit) - (44420 Is Workaround Until Core Support Exists)'),
(4454808,44389,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 26913 Credit)'),
(4454809,44389,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 26914 Credit)'),
(4454810,44389,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 26917 Credit)'),
(4454811,44389,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 26916 Credit)'),
(4454812,44389,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 26915 Credit)');

insert into creature_ai_scripts values (4454813,31144,8,0,100,0,20271,-1,0,0,33,44175,1,0,33,44420,1,0,0,0,0,0,'Training Dummy - On Judgement Spellhit (Quest 26918 Credit) - (44420 Is Workaround Until Core Support Exists)'),
(4454814,31144,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 26913 Credit)'),
(4454815,31144,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 26914 Credit)'),
(4454816,31144,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 26917 Credit)'),
(4454817,31144,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 26916 Credit)'),
(4454818,31144,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 26915 Credit)');

insert into creature_ai_scripts values (4454819,30527,8,0,100,0,20271,-1,0,0,33,44175,1,0,33,44420,1,0,0,0,0,0,'Training Dummy - On Judgement Spellhit (Quest 26918 Credit) - (44420 Is Workaround Until Core Support Exists)'),
(4454820,30527,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 26913 Credit)'),
(4454821,30527,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 26914 Credit)'),
(4454822,30527,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 26917 Credit)'),
(4454823,30527,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 26916 Credit)'),
(4454824,30527,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 26915 Credit)');

insert into creature_ai_scripts values (4454825,32666,8,0,100,0,20271,-1,0,0,33,44175,1,0,33,44420,1,0,0,0,0,0,'Training Dummy - On Judgement Spellhit (Quest 26918 Credit) - (44420 Is Workaround Until Core Support Exists)'),
(4454826,32666,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 26913 Credit)'),
(4454827,32666,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 26914 Credit)'),
(4454828,32666,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 26917 Credit)'),
(4454829,32666,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 26916 Credit)'),
(4454830,32666,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 26915 Credit)');

insert into creature_ai_scripts values (4454831,32667,8,0,100,0,20271,-1,0,0,33,44175,1,0,33,44420,1,0,0,0,0,0,'Training Dummy - On Judgement Spellhit (Quest 26918 Credit) - (44420 Is Workaround Until Core Support Exists)'),
(4454832,32667,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 26913 Credit)'),
(4454833,32667,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 26914 Credit)'),
(4454834,32667,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 26917 Credit)'),
(4454835,32667,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 26916 Credit)'),
(4454836,32667,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 26915 Credit)');

insert into creature_ai_scripts values (4454837,44171,8,0,100,0,20271,-1,0,0,33,44175,1,0,33,44420,1,0,0,0,0,0,'Training Dummy - On Judgement Spellhit (Quest 26918 Credit) - (44420 Is Workaround Until Core Support Exists)'),
(4454838,44171,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 26913 Credit)'),
(4454839,44171,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 26914 Credit)'),
(4454840,44171,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 26917 Credit)'),
(4454841,44171,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 26916 Credit)'),
(4454842,44171,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 26915 Credit)');

insert into creature_ai_scripts values (4454843,44614,8,0,100,0,20271,-1,0,0,33,44175,1,0,33,44420,1,0,0,0,0,0,'Training Dummy - On Judgement Spellhit (Quest 26918 Credit) - (44420 Is Workaround Until Core Support Exists)'),
(4454844,44614,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 26913 Credit)'),
(4454845,44614,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 26914 Credit)'),
(4454846,44614,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 26917 Credit)'),
(4454847,44614,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 26916 Credit)'),
(4454848,44614,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 26915 Credit)');

insert into creature_ai_scripts values (4454849,44703,8,0,100,0,20271,-1,0,0,33,44175,1,0,33,44420,1,0,0,0,0,0,'Training Dummy - On Judgement Spellhit (Quest 26918 Credit) - (44420 Is Workaround Until Core Support Exists)'),
(4454850,44703,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 26913 Credit)'),
(4454851,44703,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 26914 Credit)'),
(4454852,44703,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 26917 Credit)'),
(4454853,44703,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 26916 Credit)'),
(4454854,44703,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 26915 Credit)');

insert into creature_ai_scripts values (4454855,44794,8,0,100,0,20271,-1,0,0,33,44175,1,0,33,44420,1,0,0,0,0,0,'Training Dummy - On Judgement Spellhit (Quest 26918 Credit) - (44420 Is Workaround Until Core Support Exists)'),
(4454856,44794,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 26913 Credit)'),
(4454857,44794,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 26914 Credit)'),
(4454858,44794,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 26917 Credit)'),
(4454859,44794,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 26916 Credit)'),
(4454860,44794,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 26915 Credit)');

insert into creature_ai_scripts values (4454861,44820,8,0,100,0,20271,-1,0,0,33,44175,1,0,33,44420,1,0,0,0,0,0,'Training Dummy - On Judgement Spellhit (Quest 26918 Credit) - (44420 Is Workaround Until Core Support Exists)'),
(4454862,44820,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 26913 Credit)'),
(4454863,44820,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 26914 Credit)'),
(4454864,44820,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 26917 Credit)'),
(4454865,44820,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 26916 Credit)'),
(4454866,44820,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 26915 Credit)');

insert into creature_ai_scripts values (4454867,44848,8,0,100,0,20271,-1,0,0,33,44175,1,0,33,44420,1,0,0,0,0,0,'Training Dummy - On Judgement Spellhit (Quest 26918 Credit) - (44420 Is Workaround Until Core Support Exists)'),
(4454868,44848,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 26913 Credit)'),
(4454869,44848,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 26914 Credit)'),
(4454870,44848,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 26917 Credit)'),
(4454871,44848,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 26916 Credit)'),
(4454872,44848,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 26915 Credit)');

insert into creature_ai_scripts values (4454873,44937,8,0,100,0,20271,-1,0,0,33,44175,1,0,33,44420,1,0,0,0,0,0,'Training Dummy - On Judgement Spellhit (Quest 26918 Credit) - (44420 Is Workaround Until Core Support Exists)'),
(4454874,44937,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 26913 Credit)'),
(4454875,44937,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 26914 Credit)'),
(4454876,44937,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 26917 Credit)'),
(4454877,44937,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 26916 Credit)'),
(4454878,44937,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 26915 Credit)');

insert into creature_ai_scripts values (4454879,46647,8,0,100,0,20271,-1,0,0,33,44175,1,0,33,44420,1,0,0,0,0,0,'Training Dummy - On Judgement Spellhit (Quest 26918 Credit) - (44420 Is Workaround Until Core Support Exists)'),
(4454880,46647,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 26913 Credit)'),
(4454881,46647,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 26914 Credit)'),
(4454882,46647,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 26917 Credit)'),
(4454883,46647,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 26916 Credit)'),
(4454884,46647,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 26915 Credit)');

insert into creature_ai_scripts values (4454885,48304,8,0,100,0,20271,-1,0,0,33,44175,1,0,33,44420,1,0,0,0,0,0,'Training Dummy - On Judgement Spellhit (Quest 26918 Credit) - (44420 Is Workaround Until Core Support Exists)'),
(4454886,48304,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 26913 Credit)'),
(4454887,48304,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 26914 Credit)'),
(4454888,48304,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 26917 Credit)'),
(4454889,48304,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 26916 Credit)'),
(4454890,48304,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 26915 Credit)');
