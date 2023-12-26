using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;

namespace servicioBiblioteca
{
    // NOTA: puede usar el comando "Rename" del menú "Refactorizar" para cambiar el nombre de clase "Service1" en el código, en svc y en el archivo de configuración.
    // NOTE: para iniciar el Cliente de prueba WCF para probar este servicio, seleccione Service1.svc o Service1.svc.cs en el Explorador de soluciones e inicie la depuración.
    public class Service1 : IService1
    {
       
        SqlConnection con = new SqlConnection("Server=localhost;Database=dbreto;Trusted_Connection=True;Integrated Security=SSPI;");
        public DataSet GetAllBooks()
        {
            DataSet DST = new DataSet();
            SqlDataAdapter DA = new SqlDataAdapter("GetAllBooks", con);
            DA.Fill(DST, "libro");
            return DST;
        }

        public void InsertBook(BookDTO book)
        {
            con.Open();
            SqlCommand cmd = new SqlCommand("InsertBook", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@varTitle", SqlDbType.VarChar).Value = book.Title;
            cmd.Parameters.Add("@varCode", SqlDbType.VarChar).Value = book.Code;
            cmd.Parameters.Add("@instStatus", SqlDbType.Int).Value = book.Status;
            cmd.Parameters.Add("@isActiver", SqlDbType.Bit).Value = book.IsActive;
        }
           
        public bool AutenticarUsuario(string user, string pass)
        {
            DataSet DST = new DataSet();
            SqlCommand cmd = new SqlCommand("GetUserById", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@varEmail", SqlDbType.VarChar).Value = user;
            cmd.Parameters.Add("@varPassword", SqlDbType.VarChar).Value = pass;

            using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
            {
                adapter.Fill(DST);
            }
            if (DST.Tables.Count > 0 && DST.Tables[0].Rows.Count > 0)
            {
                DataRow row = DST.Tables[0].Rows[0];
                return true;
            }
            else
            {
                return false;
            }
  
        }


        public string GetData(int value)
        {
            return string.Format("You entered: {0}", value);
        }

        public CompositeType GetDataUsingDataContract(CompositeType composite)
        {
            if (composite == null)
            {
                throw new ArgumentNullException("composite");
            }
            if (composite.BoolValue)
            {
                composite.StringValue += "Suffix";
            }
            return composite;
        }

        public void InsertBook()
        {
            throw new NotImplementedException();
        }
    }
}
