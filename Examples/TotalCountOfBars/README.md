# 'TotalCountOfBars' attribute

'TotalCountOfBars' is a user-defined attribute (UDA) designed to store
the total number of bars for each reinforcement position defined in model.
Such information can be later used like regular template attributes,
for example 'NUMBER_OF_BARS_IN_GROUP', but unlike built-in attributes,
'TotalCountOfBars' is not updated automatically. It must be recalculated
manually when model changes.

The idea comes from macro "Bewehrung - Totale Anzahl pro Position" available
on Tekla Warehouse ([check this link](https://warehouse.tekla.com/#/catalog/details/e0d05391-241a-40cc-8c5f-01249b45a455)).

# Update-TotalCountOfBars
Like the name suggests, this function updates 'TotalCountOfBars' attributes.
It does this by iterating over all 'Reinforcement' objects defined in model.

This is a two step process:
- reading information from model and calculating number of bars for each
  numbering position (model should be numbered first);
- updating 'TotalCountOfBars' attributes for changed objects.

Function returns a list of updated positions.
