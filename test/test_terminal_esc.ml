(* Testing Inventory Functions*)
open OUnit2
open Terminal_esc
open Inventory

let nothing_inventory = Inventory.create_inventory ()

let inventory_test =
  "checking the basic properties of our inventory"
  >::: [
         ( "check first health" >:: fun _ ->
           assert_equal
             (Inventory.get_item_slot nothing_inventory 0)
             { health_dmg_max = 100; empty = false; item = "health-bar" } );
         ( "check slot added okay" >:: fun _ ->
           assert_equal
             (Inventory.add_item nothing_inventory
                { health_dmg_max = 50; empty = false; item = "bow" })
             "Successful!";
           assert_equal (Inventory.get_next_empty nothing_inventory) 2;
           assert_equal false (Inventory.item_slot_empty nothing_inventory 1);
           assert_equal (Inventory.item_slot_name nothing_inventory 1) "bow";
           assert_equal (Inventory.item_slot_dmg nothing_inventory 1) 50 );
         ( "get just health" >:: fun _ ->
           assert_equal (Inventory.get_health nothing_inventory) 100 );
         ( "check adding each and next empty slot" >:: fun _ ->
           assert_equal
             (Inventory.add_item nothing_inventory
                { health_dmg_max = 50; empty = false; item = "sword" })
             "Successful!";
           assert_equal (Inventory.get_next_empty nothing_inventory) 3;
           assert_equal
             (Inventory.add_item nothing_inventory
                { health_dmg_max = 50; empty = false; item = "knife" })
             "Successful!";
           assert_equal (Inventory.get_next_empty nothing_inventory) 4;
           assert_equal
             (Inventory.add_item nothing_inventory
                { health_dmg_max = 50; empty = false; item = "gun" })
             "Successful!";
           assert_equal (Inventory.get_next_empty nothing_inventory) (-1);
           assert_equal
             (Inventory.add_item nothing_inventory
                { health_dmg_max = 50; empty = false; item = "bow" })
             "Full, Unsuccessful" );
       ]

let item_test (number, dmg_num) =
  for _ = 1 to number do
    ignore
      (Inventory.add_item nothing_inventory
         { health_dmg_max = dmg_num; empty = false; item = "bow" })
  done;
  let item_check = Inventory.item_slot_name nothing_inventory number = "bow" in
  let dmg_check = Inventory.item_slot_dmg nothing_inventory number = dmg_num in
  let empty_check =
    Inventory.item_slot_empty nothing_inventory number = false
  in
  let next_slot_check =
    if number = 5 then Inventory.get_next_empty nothing_inventory = -1
    else Inventory.get_next_empty nothing_inventory = number
  in
  item_check && dmg_check && empty_check && next_slot_check

let create_other_invent =
  let random_num = QCheck2.Gen.int_bound 5 in
  let random_dmg = QCheck2.Gen.int_bound 99 in
  QCheck2.Gen.pair random_num random_dmg

let prop_inventory_test =
  QCheck_runner.to_ounit2_test
    (QCheck2.Test.make ~count:100 ~name:"rando dmg size" create_other_invent
       item_test)

let all = "whole test suite" >::: [ inventory_test; prop_inventory_test ]
let () = run_test_tt_main all
