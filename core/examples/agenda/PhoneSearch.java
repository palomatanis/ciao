/*
 * PhoneContact.java
 *
 * Created on April 26, 2001, 9:08 PM
 */
import CiaoJava.*;

/**
 *
 * @author  jcorreas
 * @version 
 */
public class PhoneSearch extends javax.swing.JDialog {

    /** Creates new form PhoneSearch */
    public PhoneSearch(java.awt.Frame parent,boolean modal) {
        super (parent, modal);
        initComponents ();
        //pack ();
    }
    
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the FormEditor.
     */
    private void initComponents() {//GEN-BEGIN:initComponents
        jPanel6 = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        jPanel7 = new javax.swing.JPanel();
        txtName = new javax.swing.JTextField();
        txtPhone = new javax.swing.JTextField();
        jPanel8 = new javax.swing.JPanel();
        jLabel3 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jPanel9 = new javax.swing.JPanel();
        txtEmail = new javax.swing.JTextField();
        txtAddress = new javax.swing.JTextField();
        jPanel10 = new javax.swing.JPanel();
        jLabel5 = new javax.swing.JLabel();
        jPanel11 = new javax.swing.JPanel();
        txtPosition = new javax.swing.JTextField();
        jPanel2 = new javax.swing.JPanel();
        rbExactMatch = new javax.swing.JRadioButton();
        rbICase = new javax.swing.JRadioButton();
        rbWCAllowed = new javax.swing.JRadioButton();
        jPanel1 = new javax.swing.JPanel();
        jPanel3 = new javax.swing.JPanel();
        jPanel4 = new javax.swing.JPanel();
        btnOk = new javax.swing.JButton();
        btnCancel = new javax.swing.JButton();
        getContentPane().setLayout(new java.awt.GridLayout(4, 2));
        setTitle("Search Dialog");
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                closeDialog(evt);
            }
        }
        );
        
        jPanel6.setLayout(new java.awt.GridLayout(2, 1));
        
        jLabel1.setText("Name");
          jPanel6.add(jLabel1);
          
          
        jLabel2.setText("Telephone");
          jPanel6.add(jLabel2);
          
          
        getContentPane().add(jPanel6);
        
        
        jPanel7.setLayout(new java.awt.GridLayout(2, 1));
        
        jPanel7.add(txtName);
          
          
        jPanel7.add(txtPhone);
          
          
        getContentPane().add(jPanel7);
        
        
        jPanel8.setLayout(new java.awt.GridLayout(2, 1));
        
        jLabel3.setText("E-mail");
          jPanel8.add(jLabel3);
          
          
        jLabel4.setText("Address");
          jPanel8.add(jLabel4);
          
          
        getContentPane().add(jPanel8);
        
        
        jPanel9.setLayout(new java.awt.GridLayout(2, 1));
        
        jPanel9.add(txtEmail);
          
          
        jPanel9.add(txtAddress);
          
          
        getContentPane().add(jPanel9);
        
        
        jPanel10.setLayout(new java.awt.GridLayout(2, 1));
        
        jLabel5.setText("Position");
          jPanel10.add(jLabel5);
          
          
        getContentPane().add(jPanel10);
        
        
        jPanel11.setLayout(new java.awt.GridLayout(2, 1));
        
        jPanel11.add(txtPosition);
          
          
        getContentPane().add(jPanel11);
        
        
        jPanel2.setLayout(new java.awt.GridLayout(3, 1));
        jPanel2.setBorder(new javax.swing.border.EtchedBorder());
        
        rbExactMatch.setLabel("Exact match");
          rbExactMatch.setSelected(true);
          jPanel2.add(rbExactMatch);
          
          
        rbICase.setLabel("Ignore case");
          jPanel2.add(rbICase);
          
          
        rbWCAllowed.setLabel("Wildcards allowed");
          jPanel2.add(rbWCAllowed);
          
          
        getContentPane().add(jPanel2);
        
        
        jPanel1.setLayout(new java.awt.GridLayout(2, 2));
        
        jPanel1.add(jPanel3);
          
          
        jPanel1.add(jPanel4);
          
          
        btnOk.setText("OK");
          btnOk.addActionListener(new java.awt.event.ActionListener() {
              public void actionPerformed(java.awt.event.ActionEvent evt) {
                  btnOkActionPerformed(evt);
              }
          }
          );
          jPanel1.add(btnOk);
          
          
        btnCancel.setText("Cancel");
          btnCancel.addActionListener(new java.awt.event.ActionListener() {
              public void actionPerformed(java.awt.event.ActionEvent evt) {
                  btnCancelActionPerformed(evt);
              }
          }
          );
          jPanel1.add(btnCancel);
          
          
        getContentPane().add(jPanel1);
        
        pack();
        java.awt.Dimension screenSize = java.awt.Toolkit.getDefaultToolkit().getScreenSize();
        java.awt.Dimension dialogSize = getSize();
        setSize(new java.awt.Dimension(400, 200));
        setLocation((screenSize.width-400)/2,(screenSize.height-200)/2);
    }//GEN-END:initComponents

  private void rbExactMatchActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_rbExactMatchActionPerformed
// Add your handling code here:
  }//GEN-LAST:event_rbExactMatchActionPerformed

    /* -----------------------------------------------------
     * Begin of Ciao specific code.
     * -----------------------------------------------------*/
    javax.swing.ButtonGroup bg = new javax.swing.ButtonGroup();

    public void show() {
        bg.add(rbExactMatch);
        bg.add(rbWCAllowed);
        bg.add(rbICase);

        super.show();
    }
  private void btnOkActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnOkActionPerformed
      // Begin Ciao specific code.
      // Gets the form data and invokes PhoneList method to do
      // the actual search.
      String filter[] = new String[5];
      filter[0] = txtName.getText();
      filter[1] = txtPhone.getText();
      filter[2] = txtEmail.getText();
      filter[3] = txtAddress.getText();
      filter[4] = txtPosition.getText();

      int searchMode;
      if (rbExactMatch.isSelected())
          searchMode = PhoneList.NORMAL;
      else if (rbWCAllowed.isSelected()) 
          searchMode = PhoneList.REG_EXP;
      else if (rbICase.isSelected())
          searchMode = PhoneList.CASE_INS;
      else
          searchMode = PhoneList.NORMAL;
      
      ((PhoneList)getOwner()).refreshList(filter, searchMode);
      setVisible(false);
      dispose();
      // End Ciao specific code.

  }//GEN-LAST:event_btnOkActionPerformed

  private void btnCancelActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnCancelActionPerformed
      // Begin Ciao specific code.
      // Closes this form.
      setVisible(false);
      dispose();
      // End Ciao specific code.
  }//GEN-LAST:event_btnCancelActionPerformed

    /** Closes the dialog */
    private void closeDialog(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_closeDialog
        setVisible (false);
        dispose ();
    }//GEN-LAST:event_closeDialog

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JPanel jPanel6;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JPanel jPanel7;
    private javax.swing.JTextField txtName;
    private javax.swing.JTextField txtPhone;
    private javax.swing.JPanel jPanel8;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JPanel jPanel9;
    private javax.swing.JTextField txtEmail;
    private javax.swing.JTextField txtAddress;
    private javax.swing.JPanel jPanel10;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JPanel jPanel11;
    private javax.swing.JTextField txtPosition;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JRadioButton rbExactMatch;
    private javax.swing.JRadioButton rbICase;
    private javax.swing.JRadioButton rbWCAllowed;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JButton btnOk;
    private javax.swing.JButton btnCancel;
    // End of variables declaration//GEN-END:variables

}
