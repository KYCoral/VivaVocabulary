$(document).ready(function () {
    $("#example").DataTable({
        paging: true,
        lengthChange: true,
        searching: true, // Ensure this option is set to true
        ordering: true,
        info: true,
        autoWidth: false,
        responsive: true,
        scrollX: true // Enable horizontal scrolling
    });
});


// JavaScript functions for handling bulk actions
function deleteSelected() {
    // Implement delete logic here
    console.log("Delete selected rows");
}

function editSelected() {
    // Implement edit logic here
    console.log("Edit selected rows");
}




    <script>
        $(document).ready(function () {
            // Function to update table content
            function updateTable() {
                $.ajax({
                    url: 'admin_table.php', // Change this to the PHP file that contains the table content
                    type: 'GET',
                    success: function (response) {
                        $('#example tbody').html($(response).find('#example tbody').html());
                        attachCheckboxListeners(); // Attach event listeners for checkboxes after AJAX call
                    }
                });
            }

            // Attach event listeners for checkboxes
            function attachCheckboxListeners() {
                const checkboxes = document.querySelectorAll('.admin-checkbox');
                const editAdminButton = document.getElementById('edit-admin');
                const editAdminValInput = document.getElementById("edit-admin-val");
                let checkedCount = 0;

                checkboxes.forEach(checkbox => {
                    checkbox.addEventListener('change', function () {
                        if (this.checked) {
                            checkedCount++;
                        } else {
                            checkedCount--;
                        }

                        if (checkedCount === 1) {
                            // Find the single checked checkbox and set its value
                            const checkedCheckbox = [...checkboxes].find(cb => cb.checked);
                            if (checkedCheckbox) {
                                editAdminValInput.value = checkedCheckbox.value;
                            }
                        } else {
                            // If no or multiple checkboxes are checked, clear the value
                            editAdminValInput.value = "";
                        }

                        editAdminButton.disabled = checkedCount !== 1; // Disable edit button if no checkbox is checked or more than one checkbox is checked

                        // Stop or start interval based on checkbox status
                        if (checkedCount > 0) {
                            stopInterval();
                        } else {
                            startInterval();
                        }
                    });
                });
            }

            // Initial table update
            updateTable();

            // Event listener for the edit button
            $("#edit-admin").click(function() {
                // Get the value from the input field
                var value = document.getElementById('edit-admin-val').value;
                console.log("Value being passed: ", value);

                // Redirect to the PHP file with the value as a query parameter
                window.location.href = 'edit_service.php?value=' + encodeURIComponent(value);
            });

            // Dummy functions to avoid errors
            function stopInterval() {
                console.log("Stopping interval");
            }

            function startInterval() {
                console.log("Starting interval");
            }
        });
    </script>


//   script for deleting admin
$(document).ready(function(){
    // AJAX code to handle deletion
    $("#confirm-delete-button").click(function(){
        // Array to store IDs of selected rows
        var selectedRows = [];

        // Iterate through each checked checkbox
        $(".admin-checkbox:checked").each(function(){
            // Push the value (ID) of checked checkbox into the array
            selectedRows.push($(this).val());
        });

        // AJAX call to send selected rows IDs to delete script
        $.ajax({
            url: "service_crud.php",
            type: "POST",
            data: {selectedRows: selectedRows},
            success: function(response){
                // Reload the page or update the table as needed
               // location.reload(); // For example, reload the page after deletion
            },
            error: function(xhr, status, error){
                //console.error("Error:", error);
            }
        });
    });
});

//reload page
function reload(){
location.reload();
}